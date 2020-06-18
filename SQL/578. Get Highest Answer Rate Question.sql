# Write your MySQL query statement below
select question_id as survey_log
from (select question_id,sum(case when action = 'answer' then 1 else 0 end) as que_ans,
     sum(case when action = 'show' then 1 else 0 end) as que_show from survey_log group by question_id)tmp
order by que_ans/que_show desc limit 1


-- 也可以直接这样做：
# Write your MySQL query statement below
select question_id as survey_log from
(select 
    question_id,
    sum(case when action = 'answer' then 1 else 0 end)/sum(case when action = 'show' then 1 else 0 end) as ratio
    from survey_log
where action in ('show','answer')
group by 1
order by ratio desc limit 1)tmp