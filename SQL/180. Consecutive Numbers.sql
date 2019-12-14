select distinct a.num as ConsecutiveNums
from Logs a   #注意，我们这里用的是inner join而不是left join 
inner join Logs b on b.id = a.id+1 and b.num = a.num
inner join Logs c on c.id = a.id+2 and c.num = a.num




#或者
select distinct a.Num as ConsecutiveNums from Logs a, Logs b, Logs c
where a.Id + 1 = b.Id
and b.Id + 1 = c.Id
and a.Num = b.Num and b.Num = c.Num
