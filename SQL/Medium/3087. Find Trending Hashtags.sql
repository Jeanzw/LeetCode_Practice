select 
concat('#',substring_index(substring_index(tweet,'#',-1),' ',1)) as hashtag,
count(distinct tweet_id) as hashtag_count
from Tweets
where date_format(tweet_date,'%Y-%m') = '2024-02'
group by 1
order by 2 desc,1 desc
limit 3

--------------------

-- Python
import pandas as pd

def find_trending_hashtags(tweets: pd.DataFrame) -> pd.DataFrame:
    tweets['after_hashtag'] = tweets.tweet.str.split('#').str[1]
    tweets['hashtag'] = tweets['after_hashtag'].str.split(' ').str[0]
    tweets['hashtag'] = '#' + tweets['hashtag']

    tweets = tweets[(tweets['tweet_date'] >= '2024-02-01') & (tweets['tweet_date'] <= '2024-02-29')]

    tweets = tweets.groupby(['hashtag'],as_index = False).tweet_id.nunique()
    return tweets.rename(columns = {'tweet_id':'hashtag_count'}).sort_values(['hashtag_count','hashtag'],ascending = [0,0]).head(3)