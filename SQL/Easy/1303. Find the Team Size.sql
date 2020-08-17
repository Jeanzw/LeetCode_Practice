with team_size as
(select team_id, count(*) as num from Employee
group by 1)

select employee_id, num as team_size from Employee e
left join team_size ts on e.team_id = ts.team_id