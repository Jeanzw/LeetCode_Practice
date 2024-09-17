with cte as
(select
team_id,
team_name,
sum(wins * 3 + draws) as points,
rank() over (order by sum(wins * 3 + draws) desc) as position,
round(percent_rank() over (order by sum(wins * 3 + draws) desc),2) as pct_rnk
from TeamStats
group by 1,2)

select 
    team_name,
    points,
    position,
    -- pct_rnk,
    case when pct_rnk <= 0.67 and pct_rnk > 0.33 then "Tier 2"
         when pct_rnk > 0.67 then "Tier 3"
         else "Tier 1"  end as tier
from cte
order by 2 desc, 1