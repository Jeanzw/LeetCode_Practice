
--这一次我做的思路就是，既然要求小于1000，那么我们就把大于1000的拿出来，然后让我们最后所取的不在这个范畴中就行

select name,bonus from Employee e left join Bonus b on e.empId = b.empId
where e.empId not in
(
select empId from Bonus where bonus >= 1000
    )

--下面是之前写的，这里我们看最后output的内容，其实他也把null给算进去了，所以我们要在where这里限制一个null
select name,bonus 
from Employee e
left join Bonus b
on e.empId = b.empId
where bonus < 1000 or bonus is null