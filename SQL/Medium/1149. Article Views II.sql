-- 这道题容易忽略说是在同一天里面这个条件，所以我们group by除了group by id以外还需要group by date
-- 而因为我们group by了两个条件，所以id可能会有重复只出现，所以我们最后用了一个distinct

select distinct id from
(select view_date, viewer_id as id, count(distinct article_id) as n from Views
group by 1,2 
having n > 1)tmp
order by id

-- 其实也可以直接算不需要两步
select distinct viewer_id as id from Views
group by view_date,viewer_id  --我不懂为什么我之后写的时候没有group by id
having count(distinct article_id) > 1
order by 1


-- Python
import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    views = views.groupby(['viewer_id','view_date'],as_index = False).article_id.nunique()
    views = views.query("article_id > 1")[['viewer_id']].drop_duplicates()
    return views.rename(columns = {'viewer_id':'id'})
