select 
    item_category as Category,
    sum(case when weekday(order_date) = 0 then quantity else 0 end) as Monday,
    sum(case when weekday(order_date) = 1 then quantity else 0 end) as Tuesday,
    sum(case when weekday(order_date) = 2 then quantity else 0 end) as Wednesday,
    sum(case when weekday(order_date) = 3 then quantity else 0 end) as Thursday,
    sum(case when weekday(order_date) = 4 then quantity else 0 end) as Friday,
    sum(case when weekday(order_date) = 5 then quantity else 0 end) as Saturday,
    sum(case when weekday(order_date) = 6 then quantity else 0 end) as Sunday
from Items i left join Orders o on i.item_id = o.item_id
group by 1
order by 1



-- 我之后做是这样做的，这样子出错的原因在于，我们可能存在这样的data
/*
Weekday          quantity      item    category
 0                 1           1          Book
 1                 1           1          Book
 1                 1           1          Book
如果按照上面的方法来做，那么直接在一个table里面处理掉
但是如果我们按照下面的方法那么得到的结果就是
category    item    Monday 
Book          1       1    
去left join
category    item    Tuesday    
Book         1        1      
Book         1        1        
那么就会造成第一个table就直接从一行数据变成两行数据了
category    item    Monday        Tuesday
Book          1       1               1
Book          1       1               1
然后我们再用一个sum，第一个Monday原本应该是1的，结果这样子处理后变成了2
这也就导致我们最后结果出错了
*/


select
item_category as Category,
ifnull(sum(a.quantity),0) as Monday,
ifnull(sum(b.quantity),0) as Tuesday,
ifnull(sum(c.quantity),0) as Wednesday,
ifnull(sum(d.quantity),0) as Thursday,
ifnull(sum(e.quantity),0) as Friday,
ifnull(sum(f.quantity),0) as Saturday,
ifnull(sum(g.quantity),0) as Sunday
from Items i
left join Orders a on i.item_id = a.item_id and weekday(a.order_date) = 0
left join Orders b on i.item_id = b.item_id and weekday(b.order_date) = 1
left join Orders c on i.item_id = c.item_id and weekday(c.order_date) = 2
left join Orders d on i.item_id = d.item_id and weekday(d.order_date) = 3
left join Orders e on i.item_id = e.item_id and weekday(e.order_date) = 4
left join Orders f on i.item_id = f.item_id and weekday(f.order_date) = 5
left join Orders g on i.item_id = g.item_id and weekday(g.order_date) = 6
group by 1
order by 1


-- 这样做比较清楚
with summary as
(select 
item_category,
order_date,
sum(quantity) as total
from Items a
left join Orders b on a.item_id = b.item_id
group by 1,2)

select
item_category as Category,
ifnull(sum(case when weekday(order_date) = 0 then total end),0) as 'Monday',
ifnull(sum(case when weekday(order_date) = 1 then total end),0) as 'Tuesday',
ifnull(sum(case when weekday(order_date) = 2 then total end),0) as 'Wednesday',
ifnull(sum(case when weekday(order_date) = 3 then total end),0) as 'Thursday',
ifnull(sum(case when weekday(order_date) = 4 then total end),0) as 'Friday',
ifnull(sum(case when weekday(order_date) = 5 then total end),0) as 'Saturday',
ifnull(sum(case when weekday(order_date) = 6 then total end),0) as 'Sunday'
from summary
group by 1
order by 1



-- Python
import pandas as pd

def sales_by_day(orders: pd.DataFrame, items: pd.DataFrame) -> pd.DataFrame:
  
    df = items.merge(orders, how='left', on='item_id').rename(columns={'item_category': 'category'})

    all_weekdays = pd.CategoricalDtype(
        categories = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'], 
        ordered=True)

    df['dayofweek'] = df['order_date'].dt.day_name().str.upper().astype(all_weekdays)

    df = df.pivot_table(index='category', columns='dayofweek', values='quantity', aggfunc='sum').reset_index()

    return df
