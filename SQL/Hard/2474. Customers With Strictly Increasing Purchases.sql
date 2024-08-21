with summary as
(select 
    customer_id, 
    year(order_date) as order_year, 
    sum(price) as price
    from Orders
group by 1,2)


-- 这一道题求递增的方式很巧妙，前面join之类的还是按照我们之前的做法
-- 但是用最后的count(*) - count(b.customer_id)=  1来看是否每一年都有对应的值
select
a.customer_id
from summary a
left join summary b 
on a.customer_id = b.customer_id 
and a.order_year + 1 = b.order_year
and a.price < b.price
group by 1
having count(*) - count(b.customer_id)=  1


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



-- Python
import pandas as pd
import numpy as np

def find_specific_customers(orders: pd.DataFrame) -> pd.DataFrame:
    orders['year'] = orders['order_date'].dt.year
    orders = orders.groupby(['customer_id','year'], as_index = False).price.sum()
    orders['next_year'] = orders.groupby(['customer_id']).year.shift(1)
    orders['next_price'] = orders.groupby(['customer_id']).price.shift(1)
    -- 这一个code是解决掉edge case：只有一年的记录
    orders['total_year'] = orders.groupby(['customer_id']).year.transform('count')

    orders = orders.query("~next_year.isna() or total_year == 1")
    orders['flg'] = np.where((orders['year'] - 1 == orders['next_year']) & (orders['price'] > orders['next_price']), 1, np.where(orders['total_year'] == 1, 1, 0))

    remove = orders.query("flg == 0")

    res = orders[~orders['customer_id'].isin(remove['customer_id'])]
    return res[['customer_id']].drop_duplicates()
