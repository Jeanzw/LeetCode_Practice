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


-- 一个易错的地方就是，可能并不存在中间的数，也就是说可能最大的有很多，最小的有很多
-- 那么在这种情况，我们如果用sql那么只可以用数量来做条件限制
with max_num as
(select count(*) as max_num from Friends
group by activity order by count(*) desc limit 1)
,min_num as
(select count(*) as min_num from Friends
group by activity order by count(*)  limit 1)

select activity from Friends
group by 1
having count(*) != (select max_num from max_num)
and count(*) != (select min_num from min_num)