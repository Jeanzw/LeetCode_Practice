select distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and ((a.login between b.login and b.logout) or (b.login between a.login and a.logout))

-- 其实对于时间的filter要一个就够了
select
distinct a.account_id
from LogInfo a
join LogInfo b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address 
and (b.login between a.login and a.logout)