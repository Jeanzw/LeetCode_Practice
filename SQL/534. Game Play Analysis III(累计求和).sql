-- 一个和rank ()一个级别的window function： sum() over ()

select player_id, event_date, 
sum(games_played) over (partition by player_id order by event_date) as games_played_so_far 
from Activity