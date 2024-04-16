with summary as
(select 
a.user_id, 
a.post_date,
count(distinct b.post_id) as post_cnt
from Posts a
inner join Posts b on a.user_id = b.user_id and datediff(a.post_date,b.post_date) between 0 and 6
where a.post_date between '2024-02-01' and '2024-02-28'
and b.post_date between '2024-02-01' and '2024-02-28'
group by 1,2)

, avg_post as
(select user_id, count(distinct post_id)/4 as avg_post from Posts
where post_date between '2024-02-01' and '2024-02-28'
group by 1
)

, max_post as
(select
user_id,
max(post_cnt) as post_cnt
from summary
group by 1)

select
a.user_id,
a.post_cnt as max_7day_posts,
avg_post as avg_weekly_posts
from max_post a
inner join avg_post b on a.user_id = b.user_id and post_cnt >= 2 * avg_post
order by 1