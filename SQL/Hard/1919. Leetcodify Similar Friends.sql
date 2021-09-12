select
distinct l1.user_id as user1_id,
l2.user_id as user2_id
from Listens l1
join Listens l2 on l1.user_id < l2.user_id and l1.song_id = l2.song_id and l1.day = l2.day
join Friendship f on l1.user_id = f.user1_id and l2.user_id = f.user2_id
group by 1,2,l1.day
having count(distinct l1.song_id) >= 3
