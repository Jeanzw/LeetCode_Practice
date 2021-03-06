select distinct a.num as ConsecutiveNums
from Logs a   --注意，我们这里用的是inner join而不是left join 
inner join Logs b on b.id = a.id+1 and b.num = a.num
inner join Logs c on c.id = a.id+2 and c.num = a.num

--这里其实不是说不能用left join，而是如果用left join需要考虑为null的事情，而且如果用left join我们就是要选择最右边的数，而不是最左边的
select distinct c.Num as ConsecutiveNums  from Logs a
left join Logs b on a.Id - 1 = b.Id and a.Num = b.Num
left join Logs c on b.Id - 1 = c.Id and b.Num = c.Num
where c.Num is not null

-- 其实用left join也可以不考虑null的事情，直接a,b,c当作一个个增大的内容，然后我们取第一个，只需要保证数是一样的就好了
select distinct a.Num as ConsecutiveNums from Logs a
left join Logs b on a.Id + 1= b.Id 
left join Logs c on a.Id + 2 = c.Id 
where a.Num = b.Num and a.Num = c.Num  --可能会出现timeout的问题，但是重新来一次应该不会有问题了

--或者
select distinct a.Num as ConsecutiveNums from Logs a, Logs b, Logs c
where a.Id + 1 = b.Id
and b.Id + 1 = c.Id
and a.Num = b.Num and b.Num = c.Num


