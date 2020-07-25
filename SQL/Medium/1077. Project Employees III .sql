select project_id,employee_id from
(select project_id,p.employee_id,experience_years,dense_rank() over (partition by project_id order by experience_years desc) as rnk from Project p
left join Employee e
on p.employee_id = e.employee_id)tmp
where rnk = 1