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

----------------------------------------

-- Python
import pandas as pd

def find_subtasks(tasks: pd.DataFrame, executed: pd.DataFrame) -> pd.DataFrame:
    # 先用我们recursive的公式利用最大的subtask给弄出来，形成一列
    max_subtask = pd.DataFrame({'subtask_id':range(1, max(tasks['subtasks_count'] + 1))})
    # 然后利用cross join使得全部连接
    merge = pd.merge(tasks,max_subtask,how = 'cross')
    # 然后我们筛选出想要的内容
    merge = merge[merge['subtask_id'] <= merge['subtasks_count']]

    # 我们要在这里用一个小技巧就是给然后再和executed表再多一列
    # 因为我们下面用这张表相连是要用到task_id和subtask_id，如果没有多一列，那么这张表就相当于直接消失了，没办法利用null值来做定位
    executed['ref'] = 1
    # 然后再和executed join起来找到null值
    summary = pd.merge(merge,executed, on = ['task_id','subtask_id'], how = 'left')
    return summary[summary['ref'].isna()][['task_id','subtask_id']]
    