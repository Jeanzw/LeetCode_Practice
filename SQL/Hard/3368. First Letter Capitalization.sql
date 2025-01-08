# Write your MySQL query statement below
select
content_id,
content_text as original_text,
INITCAP(content_text) AS converted_text
from user_content



-- Python
import pandas as pd

def process_text(user_content: pd.DataFrame) -> pd.DataFrame:
    user_content['converted_text'] = user_content['content_text'].str.title()
    return user_content.rename(columns = {'content_text':'original_text'})