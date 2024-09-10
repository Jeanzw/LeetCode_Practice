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


-- Python
import pandas as pd
import numpy as np

def find_bursty_behavior(posts: pd.DataFrame) -> pd.DataFrame:
    avg_weekly_posts = posts.query("post_date >= '2024-02-01' and post_date <= '2024-02-28'").groupby(['user_id'],as_index = False).post_id.nunique().rename(columns = {'post_id':'avg_weekly_posts'})
    avg_weekly_posts['avg_weekly_posts'] = avg_weekly_posts['avg_weekly_posts']/4

    consecutive_7_days = pd.merge(posts,posts,on = 'user_id').query("post_date_x >= '2024-02-01' and post_date_x <= '2024-02-28' and post_date_y >= '2024-02-01' and post_date_y <= '2024-02-28'")
    consecutive_7_days['days_diff'] = (consecutive_7_days['post_date_x'] - consecutive_7_days['post_date_y']).dt.days
    consecutive_7_days = consecutive_7_days.query("days_diff >= 0 and days_diff <= 6")
    consecutive_7_days = consecutive_7_days.groupby(['user_id','post_date_x'],as_index = False).post_id_y.nunique()
    consecutive_7_days = consecutive_7_days.groupby(['user_id'],as_index = False).post_id_y.max()

    summary = pd.merge(avg_weekly_posts,consecutive_7_days, on = 'user_id')
    summary['flg'] = np.where(summary['avg_weekly_posts'] * 2 <= summary['post_id_y'],1,0)
    return summary.query("flg == 1")[['user_id','post_id_y','avg_weekly_posts']].rename(columns = {'post_id_y':'max_7day_posts'})