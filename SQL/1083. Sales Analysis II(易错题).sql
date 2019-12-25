/*我最开始写的错误代码是：
select buyer_id from Sales
where product_id = 
(select product_id from Product where product_name = 'S8') 
and product_id != (select product_id from Product where product_name = 'iPhone')
这一串代码出错的原因在于，我们的确没有把Sales表格的最后一行给抽出来，但是我们把product_id = 1的给抽出来了，也就是说第一行和第三行我们都给抽出来了，所以我无论怎么改都是会抽出1和3。
所以正确的应该是从buyer_id下手，让它去匹配*/


SELECT distinct(buyer_id)
FROM Sales
WHERE buyer_id in
(SELECT s.buyer_id
FROM sales s LEFT JOIN product p
ON s.product_id=p.product_id
WHERE p.product_name='S8'
) AND buyer_id not in
(SELECT s.buyer_id
FROM sales s LEFT JOIN product p
ON s.product_id=p.product_id
WHERE p.product_name='iphone'
)
