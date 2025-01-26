-- 这道题目有一个edge case：如果在Product而不在Sales表里，那么不用提取出来

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
-- 注意：上面left join的是Product表，而不是raw表
-- 因为我们要保证最后抽出来的数据是在Sales表里面存在的
where s.product_id not in (select product_id from raw)



--再一次做的方式，把在这个范围内的求出来，不在的求出来，然后再划定我们的范围 
with spring_2019 as
(select product_id from Sales where sale_date between '2019-01-01' and '2019-03-31')
,not_spring_2019 as
(select product_id from Sales where sale_date not between '2019-01-01' and '2019-03-31')

select product_id,product_name from Product
where product_id in (select * from spring_2019)
and product_id not in (select * from not_spring_2019)


-- 思路还是和上面一样的，但是我们下面用了join没有用not in来判断
with un_product as
(select distinct product_id from Sales where sale_date > '2019-03-31' or sale_date <'2019-01-01')
, qu_product as
(select distinct product_id from Sales where sale_date between '2019-01-01' and '2019-03-31')

select 
a.product_id, a.product_name
from Product a
left join qu_product b on a.product_id = b.product_id
left join un_product c on a.product_id = c.product_id
where b.product_id is not null and c.product_id is null



-- Python
import pandas as pd

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(product,sales,on = 'product_id')
    merge['max_sale'] = merge.groupby(['product_id']).sale_date.transform('max')
    merge['min_sale'] = merge.groupby(['product_id']).sale_date.transform('min')
    merge = merge[(merge['min_sale'] >= '2019-01-01') & (merge['max_sale'] <= '2019-03-31')]
    return merge[['product_id','product_name']].drop_duplicates()