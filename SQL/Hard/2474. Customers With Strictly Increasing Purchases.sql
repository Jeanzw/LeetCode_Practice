with summary as
(select 
    customer_id, 
    year(order_date) as order_year, 
    sum(price) as price
    from Orders
group by 1,2)


-- 这一道题求递增的方式很巧妙，前面join之类的还是按照我们之前的做法
-- 但是用最后的count(*) - count(b.customer_id)=  1来看是否每一年都有对应的值
-- 因为我们需要有一个条件把符合题目标准的行给抽出来
-- 我们不能直接使用null来进行筛选，因为很可能出现对于某些customer，有几年符合题目有几年不符合题目，如果按照null筛选，这类客人也会被抽出来
select
a.customer_id
from summary a
left join summary b 
on a.customer_id = b.customer_id 
and a.order_year + 1 = b.order_year
and a.price < b.price
group by 1
having count(*) - count(b.customer_id)=  1

---------------------

-- 另外的做法
WITH CTE AS (
SELECT 
    customer_id,
    YEAR(ORDER_DATE) AS ORDER_YEAR,
    SUM(PRICE) AS PRICE
FROM ORDERS 
GROUP BY 1,2
),

CTE_3 AS (
SELECT 
    A.customer_id, 
        MAX(a.ORDER_YEAR)-MIN(a.ORDER_YEAR) AS num_years,
    COUNT(DISTINCT B.ORDER_YEAR) AS year_shopping  
FROM CTE A
LEFT JOIN CTE B
ON A.CUSTOMER_ID = B.CUSTOMER_ID AND A.ORDER_YEAR+1=B.ORDER_YEAR AND A.PRICE<B.PRICE
GROUP BY 1)

SELECT DISTINCT CUSTOMER_ID 
FROM CTE_3 
WHERE num_years=year_shopping
GROUP BY 1

---------------------

-- 如果实在想不到上面的解题方法那就一步步来
-- 先把每一年给recursive求出来对应的price
with recursive max_min as
(select customer_id, min(year(order_date)) as min_year, max(year(order_date)) as max_year from Orders group by 1)
, frame as
(select customer_id, min_year as year from max_min
union all
select a.customer_id, year + 1 as year from frame a left join max_min b on a.customer_id = b.customer_id
where year < max_year
)
-- 求和
, summary as
(select a.customer_id,a.year,ifnull(sum(b.price),0) as sum_price from frame a
left join Orders b on a.customer_id = b.customer_id and a.year = year(b.order_date)
group by 1,2)
-- 另开一列去找对应上一行的数字
, summary_last_year as
(select *, ifnull(lag(sum_price,1) over (partition by customer_id order by year),0) as last_year from summary)
-- 最后确保customer_id不在summary_last_year即可
select distinct customer_id from Orders
where customer_id not in (select customer_id from summary_last_year where sum_price <= last_year)

---------------------

-- 或者直接用join
with recursive cte as
(select customer_id, min(year(order_date)) as min_year, max(year(order_date)) as max_year from Orders group by 1)
, frame as
(select customer_id, min_year as year from cte
union all
select a.customer_id, a.year + 1 as year from frame a left join cte b on a.customer_id = b.customer_id
where year < max_year
)
, summary as
(select 
a.customer_id,
a.year,
ifnull(sum(c.price),0) as price
from frame a
left join Orders c on a.customer_id = c.customer_id and a.year = year(c.order_date)
group by 1,2
order by 1,2)
, no_increasing as
(select
distinct a.customer_id
from summary a
join summary b on a.customer_id = b.customer_id and a.year + 1 = b.year and a.price >= b.price)

select
distinct a.customer_id
from summary a
left join no_increasing b on a.customer_id = b.customer_id
where b.customer_id is null

---------------------
-- 或者直接用lead来找下一行
with cte as
(select
customer_id,
year(order_date) as order_year,
sum(price) as price
from Orders
group by 1,2
order by 1,2)
, summary as
(select
*, 
lead(order_year) over (partition by customer_id order by order_year) as next_year, --直接找到下一行对应的year
lead(price) over (partition by customer_id order by order_year) as next_price, --直接找到下一行对应的price
rank() over (partition by customer_id order by order_year desc) as rnk
from cte)
, res as --这里是为了找到不符合条件的customer，我们要保证这个数据不是最后一行，并且保证（year不连续或者price不上升）
(select
distinct customer_id
from summary
where ((next_year - 1 != order_year) or (next_price <= price)) and rnk != 1)

select
distinct a.customer_id
from Orders a
left join res b on a.customer_id = b.customer_id
where b.customer_id is null

---------------------

-- Python
import pandas as pd

def find_specific_customers(orders: pd.DataFrame) -> pd.DataFrame:
    orders['year'] = orders.order_date.dt.year
    orders = orders.groupby(['customer_id','year'], as_index = False).price.sum().sort_values(['customer_id','year'])
    orders['next_line_year'] = orders.groupby(['customer_id']).year.shift(-1)
    orders['next_line_price'] = orders.groupby(['customer_id']).price.shift(-1)
    -- 下把下一行对应的年份和价格搞出来

    total_line = orders.groupby(['customer_id'],as_index = False).year.nunique()
    -- 先求原本表中总共有多少行
    meet_require = orders[(orders['year'] + 1 == orders['next_line_year']) & (orders['price'] < orders['next_line_price'])]
    -- 满足条件后，每个customer对应多少行
    meet_require = meet_require.groupby(['customer_id'],as_index = False).year.nunique()

    merge = pd.merge(total_line,meet_require, on = 'customer_id', how ='left')
    return merge[(merge['year_x'] - 1 == merge['year_y'])|(merge['year_x'] == 1)][['customer_id']]
    -- 如果某个customer只有一年有购买记录，那么我们是当做这个客人满足条件，需要将其抽出来

---------------------

-- 另外的做法
import pandas as pd

def find_specific_customers(orders: pd.DataFrame) -> pd.DataFrame:
    orders['year'] = orders.order_date.dt.year
    orders = orders.groupby(['customer_id','year'],as_index = False).price.sum()
    orders.sort_values(['customer_id','year'], ascending = [1,1], inplace = True)
    orders['next_year'] = orders.groupby(['customer_id']).year.shift(-1)
    orders['next_price'] = orders.groupby(['customer_id']).price.shift(-1)
    orders['rnk'] = orders.groupby(['customer_id']).year.rank(ascending = False)
    
    not_meet = orders[((orders['next_year'] - 1 != orders['year']) | (orders['next_price'] <= orders['price'])) & (orders['rnk'] != 1)][['customer_id']]
    res = orders[~orders['customer_id'].isin(not_meet['customer_id'])][['customer_id']].drop_duplicates()
    return res