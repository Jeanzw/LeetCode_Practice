-- 因为count Window Function没有办法count distinct所以我们先写一个cte把project对应有多少skill求出来
with project as
(select
*, count(skill) over (partition by project_id) as total_skill
from Projects)
, summary as
(select
a.project_id,
a.total_skill,
b.candidate_id,
count(distinct b.skill) as skill_have,
sum(case when proficiency > importance then 10 
     when proficiency < importance then -5
     else 0 end) as points_change,
row_number() over (partition by a.project_id order by sum(case when proficiency > importance then 10 
     when proficiency < importance then -5
     else 0 end) desc, b.candidate_id) as rnk
from project a
left join Candidates b on a.skill = b.skill
group by 1,2,3
having total_skill = skill_have)

select project_id, candidate_id, 100 + points_change as score 
from summary 
where rnk = 1
order by 1

---------------------

-- Python
import pandas as pd
import numpy as np

def find_best_candidates(candidates: pd.DataFrame, projects: pd.DataFrame) -> pd.DataFrame:
    projects['skill_required'] = projects.groupby(['project_id']).skill.transform('nunique')
    merge = pd.merge(projects, candidates, on = 'skill')
    merge['score'] = np.where(merge['proficiency'] > merge['importance'], 10,
                           np.where(merge['proficiency'] < merge['importance'], -5,0))
    merge = merge.groupby(['project_id','candidate_id','skill_required'], as_index = False).agg(
        skill_have = ('skill','nunique'),
        score = ('score','sum')
        )
    merge = merge[merge['skill_required'] == merge['skill_have']]
    merge['score'] = 100 + merge['score']
    merge.sort_values(['project_id','score','candidate_id'], ascending = [1,0,1],inplace = True)
    return merge.groupby(['project_id']).head(1)[['project_id','candidate_id','score']]