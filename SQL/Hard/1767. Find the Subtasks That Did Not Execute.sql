with RECURSIVE cte as
(select task_id,subtasks_count,1 as subtask_id from Tasks
union all
select task_id,subtasks_count, subtask_id + 1 from cte
 where subtask_id < subtasks_count
)

select cte.task_id,cte.subtask_id
from cte
left join Executed e on cte.task_id = e.task_id and cte.subtask_id = e.subtask_id
where e.task_id is null
group by 1,2