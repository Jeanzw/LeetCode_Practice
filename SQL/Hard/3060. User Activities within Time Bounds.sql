with summary as
(select
*, row_number() over (partition by user_id order by session_start) as rnk from Sessions)

select 
distinct a.user_id
from summary a
inner join summary b 
on a.user_id = b.user_id 
and a.session_type = b.session_type 
and a.rnk < b.rnk 
-- 这道题主要在于理解题目，最开始的时候我这里的condition是a.rnk + 1 = b.rnk
-- 但是题目的意思是，在12小时内出现连续的Viewer或者Streamer
-- 那么就可能存在viewer ->  streamer -> viewer但是两个viewer是在12小时内的
and timestampdiff(hour,a.session_end,b.session_start) <= 12
order by 1