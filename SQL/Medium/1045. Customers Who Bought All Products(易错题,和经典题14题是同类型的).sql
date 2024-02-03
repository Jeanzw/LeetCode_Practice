/*
这一道题其实和经典题的❤14.查询和1号的同学（Tom）学习的课程完全相同的其他同学的信息是一种类型的题目
很容易犯的错误就是用count来帮助我们确认，但是这个是不对的
因为比如说同学1选了课程1和2，然后同学2选择了课程2和3，当我们用count来帮助我们确认其实就会觉得这两个同学选的课程内容是一样的
但是实际上只是数量一样而已

所以正确的解题思路应该是：
1.do a cartesian product (cross join in MySQL) on all customer_id eg.1,2,3 from table Customer and all product_key from table "Product ".
        cartesian product:
customer_id         product_key
1                   5
1                   6
2                   5
2                   6
3                   5
3                   6

此处的code应该是：
select distinct customer_id,p.product_key from Customer c,Product p


2.find difference between table Customer and the cartesian product
        cartesian product:                              cartesian product:
customer_id         product_key                 customer_id         product_key
1                   5                           1                   5
1                   6                           2                   6
2                   5 x                         3                   5
2                   6                           3                   6
3                   5                           1                   6
3                   6

此处的code应该是：
select * from
(select distinct customer_id,p.product_key from Customer c,Product p) a
 left join Customer cc on a.product_key = cc.product_key and a.customer_id = cc.customer_id
 这样子其实最后的结果中我们可以发现2  5这样的情况对应的其实就是null


3.list all customer_id not in the difference set (red row in the above table)
        cartesian product:                              final result
customer_id         product_key                 
1                   5                                       1
1                   6                           
2                   5 x                                     x
2                   6                           
3                   5                                       3
3                   6

第三步我们相当于就是先找到有null的customerid然后排除它


*/

select distinct customer_id from Customer
where customer_id not in
(select distinct a.customer_id from
(select distinct customer_id,p.product_key from Customer c,Product p) a
 left join Customer cc on a.product_key = cc.product_key and a.customer_id = cc.customer_id
 where cc.customer_id is null)


-- 其实这道题目想明白了就很简单
-- 首先，我们一定要保证Customer这张表的product_key是在Product里面的，那么就完成了where product_key in (select product_key from Product)
-- 接着，只要product_key在product里面，那么我们这个时候保证数量一致就没有问题
select customer_id from
(select customer_id,count(distinct product_key) as n from Customer
where product_key in (select product_key from Product)
group by 1 
having n = (select count(distinct product_key) from Product))tmp

-- 上面的解法可以进一步简单
select customer_id from Customer
where product_key in (select * from Product)
group by 1
having count(distinct product_key) = (select count(distinct product_key) from Product)



-- Not IN 其实不是很高效，用JOIN会更好一点
-- 我们之所以用JOIN就是要保证在Customer的表的产品都是在Product里面的，不然只是用数量来判断很容易出现错误：
-- 1. Customer：A B C
-- 2. Product: C D F
-- 数量都是3个，但是Customer的表里只有C产品是出现在Product里面的
with all_product_num as
(select count(distinct product_key) as product_num from Product)

select 
    customer_id
from Customer a
inner join Product b on a.product_key = b.product_key
group by 1
having count(distinct a.product_key) = (select product_num from all_product_num)