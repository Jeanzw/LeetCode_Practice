select Sales.product_id,product_name from Sales 
join Product on Product.product_id = Sales.product_id
group by Sales.product_id
having min(sale_date) >= '2019-01-01' 
       and 
       max(sale_date) <='2019-03-31'


-- 或者用逆向思维，就是先找到不在这去见之类的产品，然后找除了上面找到的产品外别的产品
select distinct s.product_id, product_name from Sales s
left join Product p
on s.product_id = p.product_id
where s.product_id not in
(select distinct s.product_id from Sales s
where sale_date < '2019-01-01' or sale_date > '2019-03-31')