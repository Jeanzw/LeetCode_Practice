-- 注意题目中说的：there should be no "holes" between ranks.
-- 也就意味着只能用dense rank了

select 
    Score, 
    dense_rank() over (order by Score desc) as 'Rank' 
    from Scores



-- Python
import pandas as pd

def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    scores['rank'] = scores['score'].rank(method='dense', ascending=False)
    return scores[['score', 'rank']].sort_values('score', ascending=False)