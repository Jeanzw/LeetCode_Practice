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
    # Self join on viewer_id and view_date, but ensure different articles
    merged_views = views.merge(views, on=["viewer_id", "view_date"])
    distinct_articles = merged_views[
        merged_views["article_id_x"] < merged_views["article_id_y"]
    ]

    # Extract unique viewer IDs who viewed more than one article on the same date
    result = (
        distinct_articles[["viewer_id"]]
        .drop_duplicates()
        .rename(columns={"viewer_id": "id"})
    )

    return result.sort_values("id").reset_index(drop=True)
