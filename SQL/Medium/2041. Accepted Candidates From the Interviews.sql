select
candidate_id
from Candidates a
inner join Rounds b on a.interview_id = b.interview_id
where years_of_exp >= 2
group by 1
having sum(score) > 15

----------------------------------

-- Python
import pandas as pd

def accepted_candidates(candidates: pd.DataFrame, rounds: pd.DataFrame) -> pd.DataFrame:
    candidates = candidates[candidates['years_of_exp'] >= 2]
    merge = pd.merge(candidates,rounds,on = 'interview_id')
    merge = merge.groupby(['candidate_id'],as_index = False).score.sum()
    merge = merge[merge['score']>15]
    return merge[['candidate_id']]