-- window function的做法：
select gender, day, sum(score_points) over (partition by gender order by day) as total from Scores
order by gender, day   --注意这里是不需要group by的，就和rank一样的原理

-----------------------

-- Mysql的做法
select a.gender, a.day,
sum(b.score_points) as total
from Scores a
left join Scores b on a.day >= b.day and a.gender = b.gender
group by a.gender, a.day
order by a.gender, a.day

-----------------------

-- Python
import pandas as pd

def running_total(scores: pd.DataFrame) -> pd.DataFrame:
    # 如果没有inplace = True那么不会对原表进行任何改动
    scores.sort_values(['gender','day'],inplace = True)
    scores['total'] = scores.groupby('gender').score_points.cumsum()
    
    # return scores
    return scores[['gender','day','total']]