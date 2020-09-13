select customer_id,name from Customers c
where customer_id in
(select customer_id from
(select customer_id, month(order_date) as month, sum(price * quantity) as amount from Product p
join Orders  o on p.product_id = o.product_id
where order_date between '2020-06-01' and '2020-07-31'
group by 1,2
having amount >= 100)tmp
group by 1
having count(*) = 2)

-- 另外的做法
SELECT customer_id, name
FROM (
    SELECT c.customer_id, c.name, 
    SUM(CASE WHEN LEFT(o.order_date, 7) = '2020-06' THEN p.price*o.quantity ELSE 0 END) AS t1, 
    SUM(CASE WHEN LEFT(o.order_date, 7) = '2020-07' THEN p.price*o.quantity ELSE 0 END) AS t2
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN product p
    ON p.product_id = o.product_id
    GROUP BY 1
    ) tmp
WHERE t1 >= 100 AND t2 >= 100