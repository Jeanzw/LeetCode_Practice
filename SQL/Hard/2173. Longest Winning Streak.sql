-- 这道题的难点在于day其实可以不连续，那么我们就找不到对应的bridge
-- 如果原来的表没有bridge那么我们就给他造一个bridge即可
-- 也就是说我用两个rank window，前者只针对player_id，后者针对player_id和result
with player_rnk as
(select player_id, match_day, result, 
rank() over (partition by player_id order by match_day) as rnk,
rank() over (partition by player_id,result order by match_day) as rnk_2
from Matches
order by 1,2
)
, duration as
(select player_id, count(distinct match_day) as duration
from player_rnk
where result = 'Win'
group by player_id, rnk - rnk_2)
, framework as
(select distinct player_id from Matches)

select
a.player_id,
ifnull(max(duration),0) as longest_streak
from framework a
left join duration b on a.player_id = b.player_id
group by 1