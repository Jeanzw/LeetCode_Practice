select distinct a.product_id,ifnull(b.new_price,10) as price from Products a
left join 
(select product_id, new_price from Products
where (product_id,change_date) in 
/*之所以用(product_id,change_date)来做定位，是因为这里(product_id, change_date) is the primary key of this table.*/
(select product_id,max(change_date) from Products
where change_date<='2019-08-16'
group by product_id))b
on a.product_id = b.product_id



/*但是这道题也可以用MS SQL Server去做，但是要注意的就是这里提供了一个新的思路：如果我们只是用rank来进行解题，其实只能得到1和2，因为在where change_date <= '2019-08-16'这一步的时候3已经被淘汰出局了
那么这个时候，我们需要思考的问题就是，如果让3重新回到局内呢？
那么我们这里才去的是union，让当初已经被淘汰出局的选手继续回到局内*/
select product_id, new_price price from (
select product_id, new_price, change_date, rank() over (partition by product_id order by change_date desc) Ranking from Products
where change_date <= '2019-08-16'
) A 
where Ranking = 1

union

/*下面的这一部分就是让所有被淘汰的选手重新回到局内，然后赋值为10*/
select distinct product_id, 10 from Products where product_id not in (
select product_id from (
select product_id, new_price price, change_date, rank() over (partition by product_id order by change_date desc) Ranking from Products
where change_date <= '2019-08-16'
) A where Ranking = 1)



-- 上面的做法是用union all来将所有选手回到局内
-- 但其实大可不必
with raw as
(select product_id, new_price as price from
(select 
*,
rank() over (partition by product_id order by change_date desc) as rnk
from Products
where change_date <= '2019-08-16')tmp
where rnk = 1)
-- 上面的cte先将我们可以处理的内容抽出来

select 
distinct p.product_id,
ifnull(price,10) as price
from Products p
left join raw r on p.product_id = r.product_id
-- 然后利用原表Products将所有的product_id抽出来成为一列
-- 然后将cte重的内容与之join即可