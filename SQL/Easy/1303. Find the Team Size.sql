with team_size as
(select team_id, count(*) as num from Employee
group by 1)

select employee_id, num as team_size from Employee e
left join team_size ts on e.team_id = ts.team_id

-- 用join来做就是：
select
e1.employee_id,
count(distinct e2.employee_id) as team_size
from Employee e1
left join Employee e2 on e1.team_id = e2.team_id
group by 1



-- 直接用window function
select 
    employee_id,
    count(employee_id) over (partition by team_id) as team_size
    from Employee