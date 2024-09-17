with cte as
(select
a.customer_id,b.category,
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
    merge = pd.merge(transactions,products,on = 'product_id')

    summary = merge.groupby(['customer_id'], as_index = False).agg(
        total_amount = ('amount','sum'),
        transaction_count = ('transaction_id','nunique'),
        unique_categories = ('category','nunique'),
        avg_transaction_amount = ('amount','mean')
    )
    summary['loyalty_score'] = (summary['transaction_count'] * 10 + (summary['total_amount']/100)).round(2)

    top_cat = merge.groupby(['customer_id','category'], as_index = False).agg(
        tt = ('transaction_id','nunique'),
        max_date = ('transaction_date','max'),
    )
    top_cat['rnk'] = top_cat.groupby(['customer_id']).tt.rank(method = 'dense', ascending = False)
    top_cat['ture_rnk'] = top_cat.groupby(['customer_id','rnk']).max_date.rank(method = 'first', ascending = False)
    top_cat = top_cat.query("rnk == 1 and ture_rnk == 1")[['customer_id','category']]

    result = pd.merge(summary,top_cat, on = 'customer_id',how ='left')
    result['avg_transaction_amount'] = result['avg_transaction_amount'].round(2)
    return result[['customer_id','total_amount','transaction_count','unique_categories','avg_transaction_amount','category','loyalty_score']].rename(columns = {'category':'top_category'}).sort_values(['loyalty_score','customer_id'], ascending = [0,1])