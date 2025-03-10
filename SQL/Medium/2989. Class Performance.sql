with cte as
(select
student_id,
assignment1 + assignment2 + assignment3 as total_score
from Scores)

select max(total_score) - min(total_score) as difference_in_score from cte

--------------------------

-- 可以直接写
select
max(assignment1 + assignment2 + assignment3) - min(assignment1 + assignment2 + assignment3) as difference_in_score
from Scores

--------------------------

-- Python
import pandas as pd

def class_performance(scores: pd.DataFrame) -> pd.DataFrame:
    scores['sum_score'] = scores['assignment1'] + scores['assignment2'] + scores['assignment3']
    difference_in_score = scores.sum_score.max() - scores.sum_score.min()
    return pd.DataFrame({'difference_in_score':[difference_in_score]})