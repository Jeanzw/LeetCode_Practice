-- Mysql
select product_id,year as first_year,quantity,price from Sales
where (product_id, year) in
(
select product_id,min(year) as first_year from Sales
group by 1)

-- MS SQL
select product_id,year as first_year,quantity,price from
(select *, rank() over (partition by product_id order by year) as rnk from Sales)tmo
where rnk = 1