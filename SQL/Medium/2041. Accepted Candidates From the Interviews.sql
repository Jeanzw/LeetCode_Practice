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
    # Approach: Conditional Index, Groupby Sum, inner merge
    # Filtering candidates who have at least two YoE
    candidates = candidates[candidates['years_of_exp'] >= 2]

    # .groupby('interview_id')['score'].sum(), filter for > 15
    rounds = rounds.groupby('interview_id')['score'].sum().reset_index(name='total_score')
    rounds = rounds[rounds['total_score'] > 15]

    # Inner merge on `interview_id`, rounds onto candidates
    result = candidates.merge(rounds, how='inner', on='interview_id')

    # Return `candidate_id`
    return result[['candidate_id']]
    