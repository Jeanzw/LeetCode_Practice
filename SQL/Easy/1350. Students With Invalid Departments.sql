select id, name from Students
where department_id not in
(select id from Departments)


-- 用join更高效
select
s.id,
s.name
from Students s
left join Departments d on s.department_id = d.id
where d.id is null