select
candidate_id
from Candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by 1
having count(distinct skill) = 3
order by 1

-- Python
import pandas as pd

def find_candidates(candidates: pd.DataFrame) -> pd.DataFrame:
    candidates = candidates[candidates['skill'].isin(['Python','Tableau','PostgreSQL'])]
    candidates = candidates.groupby(['candidate_id'],as_index = False).skill.nunique()

    candidates = candidates[candidates['skill'] == 3]
    return candidates[['candidate_id']].sort_values('candidate_id')