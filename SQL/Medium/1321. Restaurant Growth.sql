-- MS SQL
select visited_on, 
sum(sum(amount)) over (order by visited_on rows between 6 preceding and current row) as amount,
-- 上面原本sql function的处理是只有一个sum()，但是这里我们在外面再加一个sum就是因为我们每个日子只能有一条数据，所以需要将date给group by起来
-- 但是如果是原本的只有一个sum()，那么其实group by是处理不了的，因为这里并不认为是求和的形式
round(sum(sum(amount)) over (order by visited_on rows between 6 preceding and current row) / 7.0,2) as average_amount
from Customer
group by visited_on
order by visited_on  --有了order by才会按照时间顺序来加起来
offset 6 rows  --这个offset只有在MS SQL才能起作用，在mysql中是不能起作用的
-- 这个相当于就是把最开始的六行给淘汰掉




-- 如果不会offset的应用，那么可以用下面的query，也就是用rank定位
with daily_amount as
(select 
    visited_on,
    sum(amount) as total_daily_amount
    from Customer
    group by 1)

select 
    visited_on,
    amount,
    round(amount/7,2) as average_amount
    from
(select 
    visited_on,
    sum(total_daily_amount) over (order by visited_on rows between 6 preceding and current row) as amount,
    dense_rank() over (order by visited_on) as rnk
    from daily_amount)tmp
    where rnk >= 7


-- MYSQL
SELECT 
    a.visited_on, 
    SUM(b.amount) AS amount, 
    ROUND(SUM(b.amount)/7, 2) AS average_amount
FROM 
    (SELECT DISTINCT visited_on FROM Customer) a  --distinct date is required 
    JOIN Customer b ON DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
GROUP BY a.visited_on
HAVING a.visited_on >= MIN(b.visited_on) + 6;


/*
如果我们只看
select * 
FROM 
    (SELECT DISTINCT visited_on FROM Customer) a  
    JOIN Customer b ON DATEDIFF(a.visited_on, b.visited_on) BETWEEN 0 AND 6
    order by a.visited_on
那么得出的结果是：
{"headers": ["visited_on", "customer_id", "name", "visited_on", "amount"], 
 "values": [["2019-01-01", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-02", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-02", 2, "Daniel", "2019-01-02", 110], 
            ["2019-01-03", 3, "Jade", "2019-01-03", 120], 
            ["2019-01-03", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-03", 2, "Daniel", "2019-01-02", 110], 
            ["2019-01-04", 3, "Jade", "2019-01-03", 120], 
            ["2019-01-04", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-04", 4, "Khaled", "2019-01-04", 130], 
            ["2019-01-04", 2, "Daniel", "2019-01-02", 110], 
            ["2019-01-05", 3, "Jade", "2019-01-03", 120], 
            ["2019-01-05", 4, "Khaled", "2019-01-04", 130], 
            ["2019-01-05", 2, "Daniel", "2019-01-02", 110], 
            ["2019-01-05", 5, "Winston", "2019-01-05", 110], 
            ["2019-01-05", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-06", 5, "Winston", "2019-01-05", 110], 
            ["2019-01-06", 4, "Khaled", "2019-01-04", 130], 
            ["2019-01-06", 6, "Elvis", "2019-01-06", 140], 
            ["2019-01-06", 1, "Jhon", "2019-01-01", 100], 
            ["2019-01-06", 3, "...
那么基于上面的结果，我们如果要求出一天和六天前的amount的总和，其实直接对第一个visited_on进行操作就好了
而又因为我们需要去除最开始的六天，所以最后要有一个having来进行筛选
*/


# Write your MySQL query statement below
with summary as
(select visited_on, sum(amount) as amount from Customer group by 1)

select
visited_on,
sum(amount) over (order by visited_on rows between 6 preceding and current row) as amount,
round(sum(amount) over (order by visited_on rows between 6 preceding and current row)/7,2) as average_amount
from 
-- 一定要limit，这里我们给个超大的数。
LIMIT 100000
offset 6


-- Python

import pandas as pd

def restaurant_growth(customer: pd.DataFrame) -> pd.DataFrame:
    # 因为存在一个日期多条数据，所以这里我们先进行求和
    summary = customer.groupby(['visited_on'],as_index = False).amount.sum()
    # 这里我们先给summary进行排序，然后直接用排序之后的index作为我们判定排名的依据
    # 因为最后我们要把前6行给直接删去
    summary.sort_values('visited_on',inplace = True)
    summary['rank'] = summary.index
    # 开始用rolling来进行滚动求和
    summary['rolling_7'] = summary['amount'].rolling(window = 7, min_periods = 1).sum()
    summary['average_amount'] = (summary['rolling_7']/7).round(2)

    res = summary.query('rank > 5')[['visited_on','rolling_7','average_amount']].rename(columns = {'rolling_7':'amount'})
    return res