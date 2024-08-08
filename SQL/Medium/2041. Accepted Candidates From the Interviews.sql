select
candidate_id
from Candidates a
inner join Rounds b on a.interview_id = b.interview_id
where years_of_exp >= 2
group by 1
having sum(score) > 15



-- Python
import pandas as pd

def accepted_candidates(candidates: pd.DataFrame, rounds: pd.DataFrame) -> pd.DataFrame:
    candidates = candidates.query("years_of_exp >= 2")
    rounds = rounds.groupby(['interview_id'],as_index = False).score.sum()
    rounds = rounds.query("score > 15")

    res = pd.merge(candidates,rounds,on = 'interview_id')
    return res[['candidate_id']]