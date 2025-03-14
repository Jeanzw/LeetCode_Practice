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

----------------------------

-- Python
import pandas as pd

def find_bursty_behavior(posts: pd.DataFrame) -> pd.DataFrame:
    posts = posts[(posts['post_date'] >= '2024-02-01') & (posts['post_date'] <= '2024-02-28')]
    avg_weekly_posts = posts.groupby(['user_id'],as_index = False).post_id.nunique()
    avg_weekly_posts['avg_weekly_posts'] = avg_weekly_posts['post_id']/4
    
    merge = pd.merge(posts,posts,on = 'user_id')
    merge['date_diff'] = (merge['post_date_x'] - merge['post_date_y']).dt.days
    merge = merge[(merge['date_diff'] >= 0) & (merge['date_diff'] <= 6)]
    merge = merge.groupby(['user_id','post_date_x'],as_index = False).post_id_y.nunique()
    max_7day_posts = merge.groupby(['user_id'],as_index = False).post_id_y.max()


    summary = pd.merge(max_7day_posts,avg_weekly_posts,on = 'user_id')
    summary = summary[summary['post_id_y'] >= 2 * summary['avg_weekly_posts']]
    return summary[['user_id','post_id_y','avg_weekly_posts']].rename(columns = {'post_id_y':'max_7day_posts'}).sort_values('user_id')



-- 或者这样做
import pandas as pd

def find_bursty_behavior(posts: pd.DataFrame) -> pd.DataFrame:
    posts = posts[(posts['post_date'] >= '2024-02-01') & (posts['post_date'] <= '2024-02-28')]
    
    avg_weekly_posts = posts.groupby(['user_id'],as_index = False).post_id.nunique()
    avg_weekly_posts['post_id'] = avg_weekly_posts['post_id'] / 4
    
    max_7day_posts = pd.merge(posts,posts,on = 'user_id')
    max_7day_posts = max_7day_posts[((max_7day_posts['post_date_y'] - max_7day_posts['post_date_x']).dt.days >= 0) & ((max_7day_posts['post_date_y'] - max_7day_posts['post_date_x']).dt.days <= 6)]
    max_7day_posts = max_7day_posts.groupby(['user_id','post_date_x'],as_index = False).post_id_y.nunique()
    max_7day_posts = max_7day_posts.sort_values(['user_id','post_id_y'],ascending = [1,0]).groupby(['user_id']).head(1)
    
    res = pd.merge(max_7day_posts,avg_weekly_posts, on = 'user_id')
    res = res[res['post_id_y'] >= 2 * res['post_id']]
    return res[['user_id','post_id_y','post_id']].rename(columns = {'post_id_y':'max_7day_posts','post_id':'avg_weekly_posts'}).sort_values('user_id')