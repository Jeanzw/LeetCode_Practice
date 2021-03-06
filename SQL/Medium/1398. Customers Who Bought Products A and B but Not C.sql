select distinct customer_id, customer_name from Customers
where customer_id in (select customer_id from Orders where product_name = 'A')
and customer_id in (select customer_id from Orders where product_name = 'B')
and customer_id not in (select customer_id from Orders where product_name = 'C')
ORDER BY customer_id


-- 另一种做法
select c.customer_id, c.customer_name 
from Customers as c
    inner join
    (select customer_id, 
        sum(CASE
        WHEN product_name = 'A' THEN 1
        WHEN product_name = 'B' THEN 1
        WHEN product_name = 'C' THEN -1
        ELSE 0 END) as tot   
    from Orders
    group by customer_id
    having tot > 1) as o
where c.customer_id = o.customer_id
ORDER BY customer_id


-- 另一种做法
select o.customer_id,customer_name from Orders o left join Customers c on o.customer_id = c.customer_id
where product_name in ('A','B')  --这里是保证customer买了A和B
and o.customer_id not in (select customer_id from Orders where product_name = 'C')  --这里保证了customer买了C
group by 1
having count(distinct product_name) = 2