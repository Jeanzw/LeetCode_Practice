-- 因为count Window Function没有办法count distinct所以我们先写一个cte把project对应有多少skill求出来
with project_skill_required as
(select project_id, count(distinct skill) as skills_required from Projects group by 1)

,cte as
(select
a.project_id,
b.candidate_id,
c.skills_required,
count(distinct b.skill) as candidate_has,
-- 这个题目出的不好，没有说如果proficiency = importance就赋值0这个条件
100 + sum(case when proficiency > importance then 10 when proficiency < importance then -5 else 0 end) as score,
row_number() over (partition by a.project_id order by 100 + sum(case when proficiency > importance then 10 when proficiency < importance then -5 else 0 end) desc, candidate_id) as rnk
from Projects a
left join Candidates b on a.skill = b.skill
left join project_skill_required c on a.project_id = c.project_id
group by 1,2,3
having skills_required = candidate_has)


select
project_id,
candidate_id,
score
from cte
where rnk = 1 and skills_required <= candidate_has
order by 1



-- Python
import pandas as pd
import numpy as np
def find_best_candidates(candidates: pd.DataFrame, projects: pd.DataFrame) -> pd.DataFrame:
    projects_cnt = projects.groupby(['project_id'], as_index = False).skill.nunique()
    merge = pd.merge(projects,candidates,on = 'skill')
    merge['score'] = np.where(merge['importance']>merge['proficiency'],-5,
                     np.where(merge['importance']<merge['proficiency'],10,0)
                     )
    merge = merge.groupby(['project_id','candidate_id'],as_index = False).agg(
        skill_has = ('skill','nunique'),
        score = ('score','sum')
    ).sort_values(['project_id','score','candidate_id'], ascending = [0,0,1])

    summary = pd.merge(projects_cnt,merge,on = 'project_id')
    summary = summary.query("skill == skill_has")
    summary['rnk'] = summary.groupby(['project_id']).score.transform('rank',method = 'first',ascending = False)
    summary = summary.query("rnk == 1")
    summary['score'] = 100 + summary['score']
    return summary[['project_id','candidate_id','score']].sort_values('project_id')