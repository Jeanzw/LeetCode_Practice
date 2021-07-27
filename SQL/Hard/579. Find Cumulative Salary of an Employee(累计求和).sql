
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


/*但是如果真的要用MS SQL Server那么可以如下*/
-- 这道题不能用滚动求和，因为比如说Id = 1 并且Month = 7的时候，其实求出来的应该是90，因为5和6月份都没有对应的工作，所以是0，而我们7月份求的综合应该是5和6和7月份的综合
select
    Id,
    Month,
    sum(Salary) over (partition by Id order by Month asc rows between 2 preceding and current row) Salary
from Employee E
where Month != ( select max(Month) from Employee EE where E.Id = EE.Id group by EE.Id  )
order by Id asc, Month desc