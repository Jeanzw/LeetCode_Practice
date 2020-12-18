select seller_name from Seller 
where seller_id not in
(
select distinct seller_id from Orders
where year(sale_date) = 2020)
order by 1