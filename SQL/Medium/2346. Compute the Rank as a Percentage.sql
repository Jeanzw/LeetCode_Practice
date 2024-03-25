with student_rank as
(select *,
rank() over(partition by department_id order by mark desc) as rnk,
count(student_id) over (partition by department_id) as cnt
from Students
)
select 
student_id,
department_id,
ifnull(round(100 * (rnk - 1) /(cnt - 1),2),0) as percentage
from student_rank