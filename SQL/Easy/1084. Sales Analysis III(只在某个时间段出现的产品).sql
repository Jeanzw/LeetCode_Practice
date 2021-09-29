select Sales.product_id,product_name from Sales 
join Product on Product.product_id = Sales.product_id
group by Sales.product_id
having min(sale_date) >= '2019-01-01' 
       and 
       max(sale_date) <='2019-03-31'



-- 后来一次写，我是用了cte，从而会比较清楚
with product_in_spring_2019 as
(select product_id, min(sale_date) as min_date,max(sale_date) as max_date from Sales
group by 1
having min_date >= '2019-01-01' and max_date <= '2019-03-31')
-- 找出product_id是在这个时间范围内的

select product_id, product_name from Product
where product_id in (select product_id from product_in_spring_2019)
-- 直接从Product表中抽出上面cte找到的id
-- 这样做的好处就是：我们不需要使用任何的join


-- 或者用逆向思维，就是先找到不在这去见之类的产品，然后找除了上面找到的产品外别的产品
select distinct s.product_id, product_name from Sales s
left join Product p
on s.product_id = p.product_id
where s.product_id not in
(select distinct s.product_id from Sales s
where sale_date < '2019-01-01' or sale_date > '2019-03-31')

-- 上面的做法关于时间的范围可以写成not between
with raw as
(select
product_id from Sales
where sale_date not between '2019-01-01' and '2019-03-31')

select
distinct s.product_id,
product_name
from Sales s
left join Product p on s.product_id = p.product_id
where s.product_id not in (select product_id from raw)



--再一次做的方式，把在这个范围内的求出来，不在的求出来，然后再划定我们的范围 
with spring_2019 as
(select product_id from Sales where sale_date between '2019-01-01' and '2019-03-31')
,not_spring_2019 as
(select product_id from Sales where sale_date not between '2019-01-01' and '2019-03-31')

select product_id,product_name from Product
where product_id in (select * from spring_2019)
and product_id not in (select * from not_spring_2019)