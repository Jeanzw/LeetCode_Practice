select tweet_id from Tweets
where length(content) > 140
or (length(content) - length(replace(content,'#',''))) > 3
or (length(content) - length(replace(content,'@',''))) > 3
order by 1


-- Python
import pandas as pd

def find_invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    tweets = tweets[(tweets['content'].str.len() > 140) | (tweets['content'].str.count('#') > 3) | (tweets['content'].str.count('@') > 3) ]

    return tweets[['tweet_id']].sort_values('tweet_id')