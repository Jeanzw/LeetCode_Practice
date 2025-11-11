with cte as
(select
employee_id,
YEARWEEK(meeting_date, 1) as wk,
sum(duration_hours) as meeting_hours
from meetings
group by 1,2
having meeting_hours > 20)

select
a.employee_id,
a.employee_name,
a.department,
count(distinct wk) as meeting_heavy_weeks
from employees a
join cte b on a.employee_id = b.employee_id
group by 1,2,3
having meeting_heavy_weeks >= 2
order by 4 desc, 2