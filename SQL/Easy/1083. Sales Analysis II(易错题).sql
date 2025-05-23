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

----------------------

-- 上面的做法简化一点写就是：
with raw as
(select 
    buyer_id,
    product_name
    from Sales s
    left join Product p on s.product_id = p.product_id)

select distinct buyer_id from Sales
where buyer_id in (select buyer_id from raw where product_name = 'S8')
and buyer_id not in (select buyer_id from raw where product_name = 'iPhone')

----------------------

-- 这道题其实还是属于一道易错题，我又一次做的时候仍旧不能立刻读完题就写，还是需要想一下
with buyer_S8 as
(select buyer_id from Sales where product_id in (select product_id from Product where product_name = 'S8'))
-- 找出买了S8的人
, buyer_iphone as
(select buyer_id from Sales where product_id in (select product_id from Product where product_name = 'iPhone'))
-- 找出买了iphone的人

select distinct buyer_id from buyer_S8 
where buyer_id not in (select * from buyer_iphone)
-- 最后满足在买了S8的人中，找出其id不在买了iphone的人之列

----------------------

-- 我觉得上面这一系列做法还是都太复杂了，其实只需要一个cte即可
-- 这个cte就是找到购买了iPhone的人
-- 然后利用left join保证链接不到即可
with iphone as
(select 
distinct buyer_id
from Sales a
inner join Product b on a.product_id = b.product_id and b.product_name = 'iPhone'
)

select 
distinct a.buyer_id
from Sales a
inner join Product b on a.product_id = b.product_id and b.product_name = 'S8'
left join iphone c on a.buyer_id = c.buyer_id
where c.buyer_id is null

----------------------

-- Python
import pandas as pd

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales,product, on = 'product_id', how = 'left')
    S8 = merge[merge['product_name'] == 'S8']
    iPhone = merge[merge['product_name'] == 'iPhone']
    res = pd.merge(S8,iPhone,on = 'buyer_id', how = 'left')
    return res[res['seller_id_y'].isna()][['buyer_id']].drop_duplicates()

----------------------

-- 也可以
import pandas as pd

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(sales,product, on = 'product_id')
    S8 = merge[merge['product_name'] == 'S8'][['buyer_id']]
    iPhone = merge[merge['product_name'] == 'iPhone'][['buyer_id']]
    res = S8[~S8['buyer_id'].isin(iPhone['buyer_id'])].drop_duplicates()
    return res