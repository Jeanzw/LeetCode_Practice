select 
    product_id,
    max(case when store = 'store1' then price end) as store1,
    max(case when store = 'store2' then price end) as store2,
    max(case when store = 'store3' then price end) as store3
from Products 
group by 1


-- 另一种做法就是用pivot
SELECT *
FROM (
       SELECT product_id,store,price FROM Products
     )T1
PIVOT
(MAX(price) FOR store IN (
                           [store1],
                           [store2],
                           [store3]
                         ) 
)T2