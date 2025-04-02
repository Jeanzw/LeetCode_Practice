select * from cinema
where id % 2 = 1 and description != 'boring'
order by rating desc

-------------------------------

-- 求余数可以用mod
select * from cinema
where mod(id,2) = 1
and description != 'boring'
order by rating desc

-------------------------------

-- Python
import pandas as pd

def not_boring_movies(cinema: pd.DataFrame) -> pd.DataFrame:
    cinema = cinema[(cinema['id']%2 == 1) & (cinema['description'] != 'boring')]
    return cinema.sort_values('rating', ascending = False)