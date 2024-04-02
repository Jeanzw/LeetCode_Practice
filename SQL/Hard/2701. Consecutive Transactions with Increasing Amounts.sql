-- 这道题目和我们之前连续数的题目不一样的地方在于我们不仅仅是要把对应的customer_id给求出来，而是只要连续就把起止点求出来
-- 但我们逻辑还是和之前一样的，就是要找个bridge
-- 这一道题目的bridge就完全体现了date function的应用了

with summary as
(select
distinct a.customer_id,
a.transaction_date as fir,
b.transaction_date as sec,
c.transaction_date as thi,
row_number() over (partition by a.customer_id order by a.transaction_date desc) as rnk
from Transactions a
inner join Transactions b on a.customer_id = b.customer_id and datediff(day,a.transaction_date,b.transaction_date) = 1 and a.amount < b.amount
inner join Transactions c on b.customer_id = c.customer_id and datediff(day,b.transaction_date,c.transaction_date) = 1 and b.amount < c.amount)


select customer_id, min(fir) as consecutive_start, max(thi) as consecutive_end from summary
group by customer_id, dateadd(day, rnk,fir)
order by 1


