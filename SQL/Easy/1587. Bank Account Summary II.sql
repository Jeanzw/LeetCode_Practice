select name,sum(t.amount) as balance from Transactions t
left join Users u on t.account = u.account
group by 1
having balance > 10000

-- 我觉得上面的做法不对，因为如果有同名的情况出现，那么就会返回错误结果
select
-- a.account,
a.name,
sum(amount) as BALANCE
from Users a
left join Transactions b on a.account = b.account
group by 1,a.account
having BALANCE > 10000