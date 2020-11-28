select book_id,name from Books 
where available_from < '2019-05-23'
and book_id not in
(
    select book_id from Orders
where dispatch_date BETWEEN '2018-06-23' AND '2019-06-23'
group by book_id
having sum(quantity) >= 10
)

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

