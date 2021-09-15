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