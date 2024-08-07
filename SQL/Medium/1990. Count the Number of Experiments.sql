with platform as
(
select 'IOS' as platform
    union 
select 'Android' as platform
    union 
select 'Web' as platform
)
,experiment as
(
select 'Programming' as experiment_name
    union 
select 'Sports' as experiment_name
    union 
select 'Reading' as experiment_name
)
, rawdata as
(select *
from platform cross join experiment)


select 
    r.platform,
    r.experiment_name,
    ifnull(count(distinct experiment_id),0) as num_experiments
    from rawdata r
    left join Experiments e
    on r.platform = e.platform and r.experiment_name = e.experiment_name
    group by 1,2



-- Python
import pandas as pd

def count_experiments(experiments: pd.DataFrame) -> pd.DataFrame:
    platform = pd.DataFrame({'platform':['Android','IOS','Web']})
    experiment_name = pd.DataFrame({'experiment_name':['Reading','Sports','Programming']})
    summary = pd.merge(platform,experiment_name,how = 'cross')

    res = pd.merge(summary,experiments, on = ['platform','experiment_name'], how = 'left').groupby(['platform','experiment_name'],as_index = False).experiment_id.nunique().rename(columns = {'experiment_id':'num_experiments'})

    return res