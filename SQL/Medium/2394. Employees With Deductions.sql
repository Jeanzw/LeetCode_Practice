select
a.employee_id as employee_id
from Employees a
left join Logs b on a.employee_id = b.employee_id
group by 1,a.needed_hours
having ifnull(sum(ceiling(timestampdiff(second,in_time,out_time)/60)),0) < needed_hours * 60