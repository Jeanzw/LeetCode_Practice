-- 这道题的确符合hard
-- 首先我们如何自动建立一个表格里面有1月到12月的月份
-- 另外对于Drivers这一张表，我们需要知道这个表里面的日期其实是具有连续性的，也就是说，如果1月加入，那么整个2020年他都在存在的


with recursive month as
(select 1 as month union select month + 1 from month where month < 12)

, driver as
(select driver_id,
case when join_date <'2020-01-01' then 1
 else month(join_date) end as join_date
 from Drivers 
 where join_date <= '2020-12-31'
)
, ride as
(select ride_id,requested_at from Rides where requested_at between '2020-01-01' and '2020-12-31')

, accept_rides as
(select driver_id, month(requested_at) as month from AcceptedRides a join ride r on a.ride_id = r.ride_id)

select m.month, round(ifnull(100 * count(distinct a.driver_id)/count(distinct d.driver_id),0),2) as working_percentage
# month, count(distinct driver_id)
from month m
left join driver d on m.month >= d.join_date
left join accept_rides a on m.month = a.month
group by 1