select 
    user_id,
    count(distinct follower_id) as followers_count
    from Followers
    group by 1
    order by 1

------------------------------------

-- Python
import pandas as pd

def count_followers(followers: pd.DataFrame) -> pd.DataFrame:
    followers = followers.groupby(['user_id'], as_index = False).follower_id.nunique()
    return followers.rename(columns = {'follower_id':'followers_count'}).sort_values('user_id')