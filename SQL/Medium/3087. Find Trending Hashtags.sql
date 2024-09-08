select 
concat('#',substring_index(substring_index(tweet,'#',-1),' ',1)) as hashtag,
count(distinct tweet_id) as hashtag_count
from Tweets
where date_format(tweet_date,'%Y-%m') = '2024-02'
group by 1
order by 2 desc,1 desc
limit 3


-- Python
import pandas as pd

def find_trending_hashtags(tweets: pd.DataFrame) -> pd.DataFrame:
    tweets = tweets.query("tweet_date.dt.year == 2024 and tweet_date.dt.month == 2")
    tweets['after_hashtag'] = tweets['tweet'].str.split('#').str[1]
    tweets['hashtag'] = tweets['after_hashtag'].str.split(' ').str[0]
    tweets['hashtag'] = '#' + tweets['hashtag']
    result = tweets.groupby(['hashtag'],as_index = False).tweet_id.nunique()
    return result.sort_values(['tweet_id','hashtag'], ascending = [0,0]).rename(columns = {'tweet_id':'hashtag_count'}).head(3)