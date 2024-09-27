-- # Write your MySQL query statement below
select question_id as survey_log
from (select question_id,sum(case when action = 'answer' then 1 else 0 end) as que_ans,
     sum(case when action = 'show' then 1 else 0 end) as que_show from survey_log group by question_id)tmp
order by que_ans/que_show desc limit 1


-- 也可以直接这样做：
select question_id as survey_log from
(select 
    question_id,
    sum(case when action = 'answer' then 1 else 0 end)/sum(case when action in ('show','skip') then 1 else 0 end) as ratio
    from survey_log
where action in ('show','answer')
group by 1
order by ratio desc limit 1)tmp


-- 又一次做的时候我的做法：
select question_id as survey_log from
(select 
question_id,
sum(case when action = 'answer' then 1 else 0 end)/count(*) as ratio
from survey_log
where action != 'skip'
group by 1)tmp
order by ratio desc limit 1


-- 又一次做的时候我直接不用case when了
select 
    question_id as survey_log
    from survey_log
    group by 1
    order by count(answer_id)/count(question_id) desc limit 1


-- 或者在这里直接用rank来做
with cte as
(select 
question_id,
row_number() over (order by count(case when action = 'answer' then question_id end)
/
count(case when action = 'show' then question_id end) desc, question_id) as rnk
from SurveyLog
group by 1)

select question_id as survey_log from cte where rnk = 1


-- 我不懂为什么之前做的时候如果用cte都是用sum，明显相较于count，sum不是一个好的想法
with cte as
(select
    question_id,
    count(case when action = 'answer' then question_id end)
    /
    count(case when action = 'show' then question_id end) as answer_rate
from SurveyLog
group by 1)

select question_id as survey_log
from cte
order by answer_rate desc,question_id
limit 1



-- 又是奇葩test……如果一个问题回答了两次拥有用一个answer_id，那么我们就当做这个分子是两次
import pandas as pd
import numpy as np

def get_the_question(survey_log: pd.DataFrame) -> pd.DataFrame:
    survey_log['show_flg'] = np.where(survey_log['action'] == 'show', 1, 0)
    survey_log = survey_log.groupby(['question_id'],as_index = False).agg(
        answer = ('answer_id','count'),
        show = ('show_flg','sum')
    )
    survey_log['answer_rate'] =  survey_log['answer']/survey_log['show']
    # return survey_log
    return survey_log.sort_values(['answer_rate','question_id'],ascending = [0,1]).head(1)[['question_id']].rename(columns = {'question_id':'survey_log'})