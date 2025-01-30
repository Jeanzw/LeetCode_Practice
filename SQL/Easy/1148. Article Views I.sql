select distinct author_id as id from Views
where author_id = viewer_id
order by author_id 

-- Python
import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    views = views[views['author_id'] == views['viewer_id']]
    views = views[['author_id']].rename(columns = {'author_id':'id'}).drop_duplicates()
    return views.sort_values('id')