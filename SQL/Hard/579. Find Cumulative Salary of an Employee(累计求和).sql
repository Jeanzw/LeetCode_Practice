
/*我觉得我以前做的答案是基于没有理解题目一丝的情况下。
1.首先这道题是不能用滚动求和的，因为比如说Id = 1 并且Month = 7的时候，其实求出来的应该是90，因为5和6月份都没有对应的工作，所以是0，而我们7月份求的综合应该是5和6和7月份的综合
2.我们一定要保证关系是：
from Employee a
left join Employee b on a.Id = b.Id and a.Month - 1 = b.Month
而不能是
from Employee a
left join Employee b on a.Id = b.Id and a.Month + 1 = b.Month
因为比如说Id = 1并且Month = 1的时候，我们的求和是过去三个月的，但是我们并没有过去两个月的数据，所以是0，然后结果返回20，所以第一个表应该是对应最大月份的
3.我们一定要用left join而不是join，因为join相当于取交集，我们继续拿Id = 1 并且Month = 7来举例，如果我们用join，这一条数据是会被直接筛没了的，因为它不存在满足上面left join的条件
4. ifnull(A,B)，如果A不是null则取A如果A是null则取B
*/
select 
a.Id,
a.Month,
sum(ifnull(a.Salary,0) + ifnull(b.Salary,0) + ifnull(c.Salary,0)) as Salary
from Employee a
left join Employee b on a.Id = b.Id and a.Month - 1 = b.Month
left join Employee c on b.Id = c.Id and b.Month - 1 = c.Month
where (a.Id,a.Month) not in (select Id,max(Month) from Employee group by 1)
group by 1,2
order by 1,2 desc

-- 或者上面判断是否是最近一个月的方法可以直接用rank来用
with cte as
(select
a.id, a.month, ifnull(a.salary,0) + ifnull(b.salary,0) + ifnull(c.salary,0) as Salary,
dense_rank() over (partition by a.id order by a.month desc) as rnk
from Employee a
left join Employee b on a.id = b.id and a.month - 1 = b.month
left join Employee c on c.id = b.id and b.month - 1 = c.month)

select id, month, Salary from cte where rnk != 1 order by 1, 2 desc




/*但是如果真的要用MS SQL Server那么可以如下*/
-- 这道题不能用滚动求和，因为比如说Id = 1 并且Month = 7的时候，其实求出来的应该是90，因为5和6月份都没有对应的工作，所以是0，而我们7月份求的综合应该是5和6和7月份的综合
select
    Id,
    Month,
    sum(Salary) over (partition by Id order by Month asc rows between 2 preceding and current row) Salary
from Employee E
where Month != ( select max(Month) from Employee EE where E.Id = EE.Id group by EE.Id  )
order by Id asc, Month desc



-- 其实如果用recursive也是可以做的
with recursive cte as
(select Id, min(Month) as min_month,max(Month) as max_month from Employee
 group by 1
 union all
select Id, min_month + 1 as min_month,max_month from cte
where min_month < max_month
)
, cte2 as
(select Id, min_month as month
from cte)

select Id,month,sum_salary as Salary from
(select
    c.Id,
    c.month,
    e.Salary,
    sum(e.Salary) over (partition by c.Id order by c.month rows between 2 preceding and current row) as sum_salary
    from cte2 c
    left join Employee e on c.Id = e.Id and c.month = e.Month)tmp
    where Salary is not null
    and (Id,month) not in (select Id, max(Month) from Employee group by 1)
    order by 1,2 desc