-- ms sql
select activity from
(select 
    activity, 
    count(*) as num,
    dense_rank() over (order by count(*)) as rnk_acs,
    dense_rank() over (order by count(*) desc) as rnk_desc
    from Friends
group by activity) tmp
where rnk_acs != 1 and rnk_desc != 1

-- mysql
select activity 
from friends
group by activity
having count(*)> (select count(*) from friends group by activity order by 1 limit 1)
and count(*)< (select count(*) from friends group by activity order by 1 desc limit 1)