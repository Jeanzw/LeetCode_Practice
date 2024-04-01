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