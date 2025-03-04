select
artist,
count(distinct id) as occurrences
from Spotify
group by 1
order by 2 desc, 1

----------------------------

-- Python
import pandas as pd

def count_occurrences(spotify: pd.DataFrame) -> pd.DataFrame:
    spotify = spotify.groupby(['artist'], as_index = False).id.nunique()
    return spotify.rename(columns = {'id':'occurrences'}).sort_values(['occurrences','artist'], ascending = [0,1])