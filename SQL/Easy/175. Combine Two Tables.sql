select 
    FirstName, 
    LastName, 
    City, 
    State
from Person p 
left join Address a on p.PersonId = a.PersonId

-- Python
import pandas as pd

def combine_two_tables(person: pd.DataFrame, address: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(person,address,on = 'personId', how = 'left')
    return merge[['firstName','lastName','city','state']]
