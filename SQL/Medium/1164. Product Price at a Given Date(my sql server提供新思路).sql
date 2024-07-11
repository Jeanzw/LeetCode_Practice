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





-- 我再一次做的时候：
with price as
(select 
    product_id,
    new_price,
    rank() over (partition by product_id order by change_date desc) as rnk 
    from Products
where change_date <= '2019-08-16')
, product as
(select distinct product_id from Products)
-- 上面我们先把price符合条件的抽出来，然后利用product建立一张表

select 
p.product_id,
ifnull(pp.new_price,10) as price
from Product p
left join price pp on p.product_id = pp.product_id and rnk = 1
-- 然后将两张表join起来
-- 这里注意如果我们的rnk = 1是在where处join，那么其实不会有productid = 3的情况，只有将其放在join里面，那么对于productid = 3的情况会出现，但是是null






-- 在做一次的时候
with framework as
(select distinct product_id from Products)
, latest as
(select product_id,new_price as price from Products
where (product_id,change_date) in
(select product_id,max(change_date) from Products where change_date <= '2019-08-16' group by 1)
)

select 
    f.product_id,
    ifnull(price,10) as price
    from framework f
    left join latest l on f.product_id = l.product_id




-- 用Python写
import pandas as pd

def price_at_given_date(products: pd.DataFrame) -> pd.DataFrame:
    # 我们这里应该先筛选后排序，不然如果出现又有2019-08-16之前的行，也有2019-08-16之后的行，那么按照rank来找为1的就找不到了
    # 但是我们要注意，这下面的code得出来的列是：product_id, 最大的change_date，并没有对应的price
    max_find = products.query("change_date <= '2019-08-16'").groupby(['product_id']).change_date.max().reset_index()
    # merge的好处是，当我们merge之后，用来连接的列直接就省去了
    max_find = max_find.merge(products, left_on =['product_id','change_date'],right_on =['product_id','change_date'], how = 'left')
    # 然后清除重复值，把unique product_id给找出来
    dedup = products.drop_duplicates(subset = 'product_id')
    merge = max_find.merge(dedup, left_on = "product_id", right_on = "product_id", how = 'right')
    res = merge[['product_id', 'new_price_x']].fillna(10)
    return res.rename(columns = {'new_price_x':'price'})
