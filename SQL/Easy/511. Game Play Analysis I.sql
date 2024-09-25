select player_id,min(event_date) as first_login from Activity
group by 1


-- Python
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    activity = activity.groupby(['player_id'],as_index = False).agg(
        first_login = ('event_date','min')
    )
    return activity