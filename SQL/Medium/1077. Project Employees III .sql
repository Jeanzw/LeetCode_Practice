select project_id,employee_id from
(select project_id,p.employee_id,experience_years,dense_rank() over (partition by project_id order by experience_years desc) as rnk from Project p
left join Employee e
on p.employee_id = e.employee_id)tmp
where rnk = 1


-- 或者还是可以用求最小值最大值的经典做法，虽然很慢
select p.* from Project p
left join Employee e on p.employee_id = e.employee_id
where (project_id,experience_years) in 
(select 
project_id,
max(experience_years) as max_experience
from Project p
left join Employee e on p.employee_id = e.employee_id
group by 1)