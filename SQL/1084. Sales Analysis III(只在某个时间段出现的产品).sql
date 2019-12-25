select Sales.product_id,product_name from Sales 
join Product on Product.product_id = Sales.product_id
group by Sales.product_id
having min(sale_date) >= '2019-01-01' 
       and 
       max(sale_date) <='2019-03-31'
