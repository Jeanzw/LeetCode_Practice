select country_name,
case when avg_weather <= 15 then 'Cold' 
when avg_weather >= 25 then 'Hot' 
         else 'Warm' end as weather_type
from
(select country_id,  avg(weather_state) as avg_weather from Weather
where month(day) = 11
group by 1) a
         left join Countries b
         on a.country_id = b.country_id


-- 我第二次做的时候直接把avg在case when里面计算了
select  
    country_name, 
    case when avg(weather_state) <= 15 then 'Cold'
    when avg(weather_state) >= 25 then 'Hot' else 'Warm'
    end as weather_type from Weather w
    left join Countries c on w.country_id = c.country_id
    where date_format(day,'%Y-%m') = '2019-11'
    group by 1



-- Python
import pandas as pd
import numpy as np

def weather_type(countries: pd.DataFrame, weather: pd.DataFrame) -> pd.DataFrame:
    weather = weather.query("day >=  '2019-11-01' and day <= '2019-11-30'").groupby(['country_id'], as_index = False).weather_state.mean()

    merge = pd.merge(countries,weather, how = 'inner', on = 'country_id').fillna(20)
    
    merge['weather_type'] = np.where(
        merge['weather_state'] <= 15, 'Cold',
        np.where(merge['weather_state'] >= 25, 'Hot','Warm')
        )

    return merge[['country_name','weather_type']]