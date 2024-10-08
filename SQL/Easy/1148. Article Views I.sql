select distinct author_id as id from Views
where author_id = viewer_id
order by author_id 

-- Python
import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    views = views.query("author_id == viewer_id")[['author_id']].drop_duplicates()
    return views.rename(columns = {'author_id':'id'}).sort_values('id')