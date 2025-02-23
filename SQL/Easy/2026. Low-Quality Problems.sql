select
problem_id
from Problems
where likes / (likes + dislikes) < 0.6
order by 1



-- Python
import pandas as pd

def low_quality_problems(problems: pd.DataFrame) -> pd.DataFrame:
    problems = problems[problems['likes']/(problems['likes'] + problems['dislikes']) < 0.6]
    return problems[['problem_id']].sort_values('problem_id')