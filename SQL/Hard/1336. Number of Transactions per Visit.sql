-- 我们下面的这种做法是不正确的，因为对于transactions_count = 2的情况我们是没有办法显示的
-- 那么我们需要的是什么？我们缺少一个从0 - max(transactions_count)的列表
-- 下面的步骤只是让我们统计出原表中可以显示的内容，但是我们需要另外的一个表只是显示transaction #
select times as transactions_count, count(*) as visits_count from
(select a.user_id, a.visit_date,
sum(case when b.user_id is null then 0 else 1 end) as times
from Visits a
left join Transactions b on a.user_id = b.user_id and a.visit_date = b.transaction_date
group by 1,2)tmp
group by 1


-- 我们直接用mysql的recursive来解这道题
with recursive rawdata as
(select
v.user_id,
v.visit_date,
count(t.transaction_date) as transaction
from Visits v
left join Transactions t on v.user_id = t.user_id and v.visit_date = t.transaction_date
group by 1,2
)
,base as --虽然我们代表recursive的query在第二个cte出现，但是recursive要写在第一个cte处
(select 0 as transactions
union all
 select transactions + 1 as transactions from base
 where transactions < (select max(transaction) as max_t from rawdata)
)

select 
c.transactions as transactions_count,
ifnull(count(r.user_id),0) as visits_count
from base c
left join rawdata r on c.transactions = r.transaction
group by c.transactions





-- 另一种发发生成transactions_count从0到最大值的过程
-- 用row_number，然后union all 0
with sub1 as
(select times as transactions_count, count(*) as visits_count from
(select a.user_id, a.visit_date,
sum(case when b.user_id is null then 0 else 1 end) as times
from Visits a
left join Transactions b on a.user_id = b.user_id and a.visit_date = b.transaction_date
group by a.user_id, a.visit_date)tmp
group by times)
-- 最里面的subquery：相当于查看在visit中到底有多少人做过transaction
-- 上面这一步其实是很基础的就是用case when求有多少transaction有多少visit

-- 这道题最有意思的是下面的步骤
-- 也就是我先把Transaction这张表排序
-- 我们最后的表Result其实transactions_count其实也是一个排序，但是Result这张表的排序怎么都不可能多于Transactions这张表的排序
-- 基于上面这个事实，我们先对Transations这张表排序，而后保证这个排序是小于我们上面计算的transactions count的最大值即可
SELECT rank as transactions_count, ifnull(visits_count,0) visits_count
FROM (SELECT ROW_NUMBER() OVER (ORDER BY transaction_date) rank FROM Transactions UNION SELECT 0) sub2
LEFT JOIN sub1
ON sub2.rank = sub1.transactions_count
WHERE rank <= (SELECT MAX(transactions_count) FROM sub1)
ORDER BY 1


-- 这里涉及一个知识点：ROW_NUMBER, RANK, DENSE_RANK的区别：
-- https://blog.csdn.net/yjgithub/article/details/76136737