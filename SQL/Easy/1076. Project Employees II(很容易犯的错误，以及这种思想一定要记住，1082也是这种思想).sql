-- 这道题我最开始好像一直想要用max(count(*))这样的方式来计算count最大者，这样是不对的，做不出来的
-- 但是就算是以下做法也是错的，因为可能好几个的project的人数都是一样的
-- select count(*) from Project
-- group by project_id
-- order by count(distinct employee_id) desc limit 1

select project_id from Project 
group by project_id
having count(*) =
(select count(*) from Project group by project_id order by count(*) desc limit 1)

/*无论是求最大还是最小，如果不是直接涉及max可以做到的情况之下，都要用where来进行选择一番
但是如果是MS SQL Server那么就直接ranking来解决了*/

select project_id from
(select project_id,dense_rank() over (order by count(*) desc) as ranking from Project
group by project_id)tmp
where ranking = 1



-- Python
import pandas as pd

def project_employees_ii(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    project = project.groupby(['project_id'],as_index = False).employee_id.nunique()
    project['rnk'] = project.employee_id.rank(ascending = False)
    return project.query("rnk == 1")[['project_id']]


-- 也可以
import pandas as pd

def project_employees_ii(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    project = project.groupby(['project_id'],as_index = False).employee_id.nunique()
    project['max_cnt'] = project.employee_id.max()
    project = project[project['max_cnt'] == project['employee_id']]
    return project[['project_id']]