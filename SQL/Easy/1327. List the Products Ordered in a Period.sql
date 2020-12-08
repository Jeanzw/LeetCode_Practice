select product_name, sum(unit) as unit from Orders o
left join Products p on o.product_id = p.product_id
where order_date between '2020-02-01' and '2020-02-29'
group by 1
having unit >= 100



-- 下面是我第二次做的，对比还是上面的更简单
with orders as
(select product_id,sum(unit) as unit from Orders
where order_date between '2020-02-01' and '2020-02-29'
group by 1
having unit >= 100)

select product_name,unit from Products p
join orders o on p.product_id = o.product_id