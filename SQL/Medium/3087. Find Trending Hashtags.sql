select 
concat('#',substring_index(substring_index(tweet,'#',-1),' ',1)) as hashtag,
count(distinct tweet_id) as hashtag_count
from Tweets
where date_format(tweet_date,'%Y-%m') = '2024-02'
group by 1
order by 2 desc,1 desc
limit 3