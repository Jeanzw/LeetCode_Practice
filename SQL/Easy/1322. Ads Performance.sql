select ad_id,
ifnull(round(100 *sum(case when action = 'Clicked' then 1 else 0 end) 
/
sum(case when action = 'Clicked' or action = 'Viewed' then 1 else 0 end),2),0.00) as ctr
from Ads
group by 1
order by ctr desc, ad_id