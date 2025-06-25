with cte as
(select
student_id,
subject,
score,
count(*) over (partition by student_id,subject) as cnt,
rank() over (partition by student_id,subject order by exam_date) as rnk,
rank() over (partition by student_id,subject order by exam_date desc) as rnk_desc
from Scores)

select
a.student_id,
a.subject,
b.score as first_score,
a.score as latest_score
from cte a
join cte b on a.student_id = b.student_id and a.subject = b.subject and a.cnt > 1 and a.rnk_desc = 1 and b.rnk = 1 and a.score > b.score

------------------------

-- 用Python做
import pandas as pd

def find_students_who_improved(scores: pd.DataFrame) -> pd.DataFrame:
    scores['rnk'] = scores.groupby(['student_id','subject']).exam_date.rank()
    scores['rnk_desc'] = scores.groupby(['student_id','subject']).exam_date.rank(ascending = False)
    first_score = scores[scores['rnk'] == 1]
    last_score = scores[scores['rnk_desc'] == 1]

    merge = pd.merge(first_score, last_score, on = ['student_id','subject'])
    merge = merge[(merge['exam_date_x'] < merge['exam_date_y']) & (merge['score_x'] < merge['score_y'])]
    return merge[['student_id','subject','score_x','score_y']].rename(columns = {'score_x':'first_score', 'score_y':'latest_score'}).sort_values(['student_id','subject'])