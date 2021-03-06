/*
比较常规的做法，先把2021-01-01给原数据加上
而后将原数据根据visit_date来排序
排了序之后就可以按照排序来定位前后时间，然后用datediff就可以来算时间差了
*/
with raw_data as
(select user_id, visit_date from UserVisits
union all
select distinct user_id, '2021-01-01' as visit_date from UserVisits)
, rank_date as
(select user_id, visit_date,row_number() over (partition by user_id order by visit_date) as date_rank from raw_data)

select 
a.user_id,
max(datediff(b.visit_date,a.visit_date)) as biggest_window
from rank_date a
left join rank_date b on a.date_rank + 1 = b.date_rank and a.user_id = b.user_id
group by 1


-- 用LEAD解法 - Mysql版本
select
    user_id,
    max(window1) biggest_window
from
(
select
    user_id,
    abs(datediff( visit_date, ifnull( lead(visit_date) over(partition by user_id order by visit_date), '2021-1-1'))) window1
from UserVisits 
) t    
group by user_id
order by 1


-- 用LEAD解法 - Sql Server版本
select
    user_id,
    max(window1) biggest_window
from
(
select
    user_id,
    abs(datediff( dd, visit_date, isnull( lead(visit_date) over(partition by user_id order by visit_date), '2021-1-1'))) window1
from UserVisits 
) t    
group by user_id
order by 1