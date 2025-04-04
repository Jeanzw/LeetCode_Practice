select book_id,name from Books 
where available_from < '2019-05-23'
and book_id not in
(
    select book_id from Orders
where dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
group by book_id
having sum(quantity) >= 10
)

----------------------------------

-- 上面的query如果变成cte的形式会更加简洁
with available_date as
(select book_id,name from Books
where datediff('2019-06-23',available_from) > 30)
-- 找出available_from的时间是在一个月以前的book_id和name
, book_sold as
(select book_id, sum(quantity) as num from Orders 
 where dispatch_date between '2018-06-23' and '2019-06-23'
group by 1 having num >= 10)
-- 由于比如说book_id其实是不在Orders这个表中的，所以我们不能直接抽取卖的数量小于10的书籍
-- 而是只能逆向思维，考虑卖的数量大于10的书籍，然后最后用一个not in来处理
select * from available_date
where book_id not in (select book_id from book_sold)

----------------------------------

-- 或者直接不用cte来进行求解
select
b.book_id,
b.name
from Books b
left join Orders o  on o.book_id = b.book_id 
and dispatch_date between  '2018-06-23' and '2019-06-23'  
-- 这个条件如果放在where里面，那么就会把我们join的结果进行筛掉
-- 而如果放在这里，那么匹配不上的只会显示null
where available_from <= '2019-05-23'
group by 1,2
having sum(quantity) <10 or sum(quantity) is null 
-- 上面的having也可以改成：
-- having ifnull(sum(quantity),0) < 10
-- 但无论改成什么，这里的意思就是要保证没有卖出去一本书的书也是可以被提取出来的

----------------------------------

-- Python
import pandas as pd

def unpopular_books(books: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    books = books[books['available_from'] < '2019-05-23']
    orders = orders[orders['dispatch_date'] > '2018-06-23']

    merge = pd.merge(books,orders, on = 'book_id', how = 'left').fillna(0)
    merge = merge.groupby(['book_id','name'],as_index = False).quantity.sum()
    merge = merge[merge['quantity'] < 10]
    return merge[['book_id','name']]