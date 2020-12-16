select name as customer_name, tmp.customer_id, order_id, order_date from
(select 
    customer_id, 
    order_id, 
    order_date, 
    rank() over(partition by customer_id order by order_date desc) as rnk from Orders)tmp
join Customers c on tmp.customer_id = c.customer_id
where rnk <= 3
order by name, customer_id, order_date desc