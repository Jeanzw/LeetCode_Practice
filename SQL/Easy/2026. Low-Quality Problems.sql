select
problem_id
from Problems
where likes / (likes + dislikes) < 0.6
order by 1



-- Python
import pandas as pd

def low_quality_problems(problems: pd.DataFrame) -> pd.DataFrame:
    problems['pct'] = problems['likes']/(problems['likes'] + problems['dislikes'])
    problems = problems.query("pct < 0.6")
    return problems[['problem_id']].sort_values('problem_id')