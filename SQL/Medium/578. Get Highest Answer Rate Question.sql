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