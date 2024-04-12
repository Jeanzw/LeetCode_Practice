with rnk as
(select user_id, session_type, row_number() over (partition by user_id order by session_start) as rnk from Sessions)
, user as
(select user_id from rnk where rnk = 1 and session_type = 'Viewer')

select a.user_id, count(distinct session_id) as sessions_count
from Sessions a
inner join user b on a.user_id = b.user_id
where a.session_type = 'Streamer'
group by 1
order by 2 desc,1 desc