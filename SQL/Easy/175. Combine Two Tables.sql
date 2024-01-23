select 
    FirstName, 
    LastName, 
    City, 
    State
from Person p 
left join Address a on p.PersonId = a.PersonId

-- 用pandas
result = pd.merge(person, address, on='personId', how='left')
result = result[['firstName', 'lastName', 'city', 'state']]


import pandas as pd

def combine_two_tables(person: pd.DataFrame, address: pd.DataFrame) -> pd.DataFrame:
    result = pd.merge(person, address, on='personId', how='left')
    result = result[['firstName', 'lastName', 'city', 'state']]
    return result