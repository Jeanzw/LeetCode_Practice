with nation as
(select avg(price) as nation_avg from Listings)
, city_avg as
(select
city, avg(price) as city_avg
from Listings
group by 1)

select
city
from city_avg,nation
where city_avg > nation_avg
order by 1