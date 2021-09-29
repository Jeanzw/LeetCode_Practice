select customer_id from
(select customer_id,count(distinct product_key) as n from Customer
where product_key in (select product_key from Product)
group by 1 
having n = (select count(distinct product_key) from Product))tmp

-- 上面可以直接写成
select
customer_id
from Customer
where product_key in (select product_key from Product)
group by 1
having count(distinct product_key) = (select count(distinct product_key) from Product)



-- 其实也可以直接用cte来做，这个会比较清楚一点
with raw_customer as
(select * from Customer
where product_key in (select product_key from Product)
group by customer_id,product_key)
-- 这里我们保证对于customer这一个表中，每一行的数据都是unique的
, product_num as
(select count(distinct product_key) from Product)
-- 这里我们是计算出有多少个product

select customer_id from raw_customer
group by 1
having count(*) = (select * from product_num)