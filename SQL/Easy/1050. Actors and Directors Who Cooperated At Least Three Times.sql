select actor_id,director_id from ActorDirector
group by actor_id,director_id
having count(distinct timestamp) >= 3


-- Python
import pandas as pd

def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    actor_director = actor_director.groupby(['actor_id','director_id'],as_index = False).timestamp.nunique()
    return actor_director.query("timestamp >= 3")[['actor_id','director_id']]