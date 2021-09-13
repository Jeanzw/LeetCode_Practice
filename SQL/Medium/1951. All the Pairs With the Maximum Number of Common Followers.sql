with rawdata as
(select
r1.user_id as user1_id,
r2.user_id as user2_id,
count(distinct r1.follower_id) as common
from Relations r1
join Relations r2 on r1.user_id != r2.user_id and r1.follower_id = r2.follower_id
where r1.user_id < r2.user_id
group by 1,2)

select 
    user1_id,
    user2_id 
    from rawdata
where common = (select max(common) from rawdata)


-- 上面是用max来求最大值，下面是用dense rank来求
with rawdata as
(select
r1.user_id as user1_id,
r2.user_id as user2_id,
dense_rank() over (order by count(distinct r1.follower_id) desc) as rnk
from Relations r1
join Relations r2 on r1.user_id != r2.user_id and r1.follower_id = r2.follower_id
where r1.user_id < r2.user_id
group by 1,2)

select 
    user1_id,
    user2_id 
    from rawdata
    where rnk = 1