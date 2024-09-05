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
    candidates = candidates.query("skill == 'Python' or skill == 'Tableau' or skill == 'PostgreSQL' ")
    candidates = candidates.groupby(['candidate_id'],as_index = False).skill.nunique()
    return candidates.query("skill == 3")[['candidate_id']].sort_values('candidate_id')