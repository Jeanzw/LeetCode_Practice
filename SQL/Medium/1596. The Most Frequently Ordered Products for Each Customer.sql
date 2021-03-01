with max_product as
(select 
    customer_id,
    product_id,
    count(*) as cnt,
    dense_rank() over (partition by customer_id order by count(*) desc) as rnk
    -- 这里其实我们可以直接用count(*)来排序，但是要注意的是，那么如果我们这里用了aggregate，那么就要当作aggregate来对待
    -- 无论我们上面count(*) as cnt是否存在，下面的group by都是存在的
    from Orders group by 1,2)
    
    select m.customer_id,m.product_id,product_name from max_product m
    left join Products p on m.product_id = p.product_id
    where rnk = 1

-- 我其实觉得不能什么都用cte做，因为据说有些公司的sql不推荐用cte因为看不到logic
-- 这道题如果直接做其实也很简单的
select customer_id,product_id,product_name from
(select 
o.customer_id, 
o.product_id,
p.product_name,
dense_rank() over (partition by customer_id order by count(*) desc) as rnk 
from Orders o 
left join Products p on o.product_id = p.product_id
group by 1,2,3)tmp
where rnk = 1



-- 我们也可以不用rank来做
SELECT customer_id,products.product_id,product_name
from Orders
JOIN Products on Products.product_id=Orders.product_id
group by customer_id,product_id
HAVING (customer_id,COUNT(order_date)) IN(
-- #Get Maxiumum Count for each customer 
SELECT customer_id,MAX(cnt)FROM
(
SELECT customer_id,product_id,COUNT(order_date) as cnt
from Orders
group by customer_id,product_id
) as a
group by customer_id)