select title from Content
where Kids_content = 'Y' 
and content_type = 'Movies'
and content_id in 
(select content_id from TVProgram
where program_date between '2020-06-01' and '2020-06-30')


-- 或者直接用join也可以
select 
distinct title
from TVProgram t join Content c on t.content_id = c.content_id
where program_date between '2020-06-01' and '2020-06-30'
and content_type = 'Movies'
and Kids_content = 'Y'


-- Python
import pandas as pd

def friendly_movies(tv_program: pd.DataFrame, content: pd.DataFrame) -> pd.DataFrame:
    # 因为原表中两个content_id虽然名字一样，但是一个是int一个是var，所以我们需要改动数据结构
    content["content_id"] = pd.to_numeric(content["content_id"])
    merge = pd.merge(tv_program,content, on = 'content_id', how = 'inner').query("Kids_content == 'Y' and content_type == 'Movies' and program_date.dt.month == 6 and program_date.dt.year == 2020")

    return merge[['title']].drop_duplicates()