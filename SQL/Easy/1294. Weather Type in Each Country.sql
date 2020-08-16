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