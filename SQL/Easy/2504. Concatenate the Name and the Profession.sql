select 
person_id,
concat(name,'(',left(profession,1),')') as name
from Person
order by 1 desc


-- Python
import pandas as pd

def concatenate_info(person: pd.DataFrame) -> pd.DataFrame:
    person['name'] = person['name'] + '(' + person['profession'].str[:1] + ')'
    return person[['person_id','name']].sort_values(['person_id'], ascending = False)