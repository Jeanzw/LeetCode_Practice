with cte as
(select
a.customer_id,b.category,
-- 上面只能有customerid和category，如果我们加上product_id那么在排序的时候其实是在Product的层面上排序而不是在category层面上
sum(amount) as total_amount,
count(distinct a.transaction_id) as transaction_count,
-- 我们下面的order by要注意用max(transaction_date)，因为我们以category来做groupby，我们去找每个类别中最大的日期，然后进行比较
rank() over (partition by a.customer_id order by count(distinct a.transaction_id) desc, max(transaction_date) desc) as rnk
from Transactions a
inner join Products b on a.product_id = b.product_id
group by 1,2)

select 
    customer_id,
    sum(total_amount) as total_amount,
    sum(transaction_count) as transaction_count,
    count(distinct category) as unique_categories,
    round(sum(total_amount)/sum(transaction_count),2) as avg_transaction_amount,
    max(case when rnk = 1 then category end) as top_category,
    round((sum(transaction_count) * 10) + (sum(total_amount)/100),2) as loyalty_score
from cte
group by 1
order by 7 desc, 1



-- python
import pandas as pd

def analyze_customer_behavior(transactions: pd.DataFrame, products: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(transactions,products,on = 'product_id', how = 'left')
    merge = merge.groupby(['customer_id','category'], as_index = False).agg(
        total_amount = ('amount','sum'),
        transaction_count = ('transaction_id','nunique'),
        transaction_date = ('transaction_date','max')
    )
    merge.sort_values(['customer_id','transaction_count','transaction_date'], ascending = [1,0,0],inplace = True)
    top_category = merge.groupby(['customer_id'],as_index = False).head(1)[['customer_id','category']]
    
    summary = merge.groupby(['customer_id'],as_index = False).agg(
        total_amount = ('total_amount','sum'),
        transaction_count = ('transaction_count','sum'),
        unique_categories = ('category','nunique')
    )
    summary['avg_transaction_amount'] = round(summary['total_amount']/ summary['transaction_count'] + 1e-9,2)
    summary['loyalty_score'] = round(summary['transaction_count'] * 10 + summary['total_amount']/100 + 1e-9 ,2)
    

    res = pd.merge(summary,top_category,on = 'customer_id')
    return res[['customer_id','total_amount','transaction_count','unique_categories','avg_transaction_amount','category','loyalty_score']].sort_values(['loyalty_score','customer_id'], ascending = [0,1]).rename(columns = {'category':'top_category'})