select
distinct a.user_id
from Confirmations a
join Confirmations b on a.user_id = b.user_id and a.time_stamp < b.time_stamp
where TIMESTAMPDIFF(SECOND,a.time_stamp,b.time_stamp) <= 86400