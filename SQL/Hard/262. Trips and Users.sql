-- 知识点：
-- 1. 保留几位小数round(xxx,2)


select Request_at as Day,
ifnull(round(sum(case when Status != 'completed' then 1 end)/count(*),2),0.00) as 'Cancellation Rate' from  #这里如果我们写成：round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2)那么就不需要用到ifnull了
(select Client_Id,Driver_Id, Status, Request_at from Trips a 
join Users b on a.Client_Id = b.Users_Id and b.Banned != 'Yes'  --这里用join是因为我们相当于在这里就把有Banned的内容给剔除了
join Users c on a.Driver_Id = c.Users_Id and c.Banned != 'Yes') tmp
where Request_at BETWEEN '2013-10-01' AND '2013-10-03'
group by Request_at



-- 其实也可以不用join来筛选unbanned的内容，直接用where来进行筛选
-- 下面是我后来写的
select Request_at as Day,
ifnull(round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2),0.00) as 'Cancellation Rate'
from Trips

where Client_Id in (select Users_Id from Users where Banned != 'Yes')
and Driver_Id in (select Users_Id from Users where Banned != 'Yes')
and Request_at BETWEEN '2013-10-01' AND '2013-10-03'

group by Request_at

-- 这里我们需要注意的是一定要是case when Status != 'completed' then 1 else 0 end，因为calcelled by可以是client也可以是driver，如果用calcelled那么就会比较麻烦
