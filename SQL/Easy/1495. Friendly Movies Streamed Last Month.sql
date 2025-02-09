select title from Content
where Kids_content = 'Y' 
and content_type = 'Movies'
and content_id in 
(select content_id from TVProgram
where program_date between '2020-06-01' and '2020-06-30')

--------------------

-- 或者直接用join也可以
select 
distinct title
from TVProgram t join Content c on t.content_id = c.content_id
where program_date between '2020-06-01' and '2020-06-30'
and content_type = 'Movies'
and Kids_content = 'Y'

--------------------

-- Python
import pandas as pd

def friendly_movies(tv_program: pd.DataFrame, content: pd.DataFrame) -> pd.DataFrame:
    content['content_id'] = content['content_id'].astype(int)
    merge = pd.merge(content,tv_program,on = 'content_id')
    merge = merge[(merge['Kids_content'] == 'Y') & (merge['content_type'] == 'Movies') & (merge['program_date'].dt.year == 2020) & (merge['program_date'].dt.month == 6)]
    return merge[['title']].drop_duplicates()