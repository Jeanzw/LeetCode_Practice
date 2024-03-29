select actor_id,director_id from ActorDirector
group by actor_id,director_id
having count(distinct timestamp) >= 3


-- Python
import pandas as pd

def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    cnts = actor_director.groupby(['actor_id', 'director_id']).size().reset_index(name='counts')
    return cnts[cnts['counts'] >= 3][['actor_id', 'director_id']]