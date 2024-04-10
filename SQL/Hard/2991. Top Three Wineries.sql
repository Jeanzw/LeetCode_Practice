with cte as
(select
country, winery,sum(points) as points, row_number() over (partition by country order by sum(points) desc, winery) as rnk
from Wineries
group by 1,2)

select
country,
ifnull(max(case when rnk = 1 then concat(winery,' (',points,')') end),'No first winery') as top_winery,
ifnull(max(case when rnk = 2 then concat(winery,' (',points,')') end),'No second winery') as second_winery,
ifnull(max(case when rnk = 3 then concat(winery,' (',points,')') end),'No third winery') as third_winery
from cte 
group by 1
order by 1