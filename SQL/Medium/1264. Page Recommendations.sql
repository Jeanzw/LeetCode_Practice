select distinct page_id as recommended_page from
(
select user1_id as user_id,user2_id as friend from Friendship where user1_id = 1
union all
select user2_id as user_id,user1_id as friend from Friendship where user2_id = 1)tmp
left join Likes l on tmp.friend = l.user_id
where page_id not in
(select page_id from Likes where user_id = 1) and page_id is not null

-- 我在第二次做的时候其实没有做出来，问题就在于，我没考虑用page_id来作为定位，因为我们保证user_id = 1的page_id其实是不能用的，所以需要将此给剔除掉
-- 如果不这样做，其实我们回发现，在Likes里面的6号选手，他的page和1号选手其实是一样的，所以我们需要将此剔除掉