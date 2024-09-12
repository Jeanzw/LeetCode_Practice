select tweet_id from Tweets
where length(content) > 140
or (length(content) - length(replace(content,'#',''))) > 3
or (length(content) - length(replace(content,'@',''))) > 3
order by 1


-- Python
import pandas as pd

def find_invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    tweets['len'] = tweets['content'].str.len()
    tweets = tweets.query("content.str.len()>140 or content.str.count('#') > 3 or content.str.count('@') > 3")
    return tweets[['tweet_id']].sort_values('tweet_id')