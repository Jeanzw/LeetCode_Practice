with player_info as
(select player,count(*) as cnt from
(select Wimbledon as player from Championships
union all
select Fr_open as player from Championships
union all
select US_open as player from Championships
union all
select Au_open as player from Championships)tmp
group by 1)

select 
player_id,player_name,cnt as grand_slams_count
from Players p
join player_info pp on p.player_id = pp.player 


-- 还可以用case when来解决这道题
SELECT * 
FROM (
  SELECT 
   player_id,
   player_name,
   SUM( CASE WHEN player_id = Wimbledon THEN 1 ELSE 0 END +
        CASE WHEN player_id = Fr_open THEN 1 ELSE 0 END +
        CASE WHEN player_id = US_open THEN 1 ELSE 0 END +
        CASE WHEN player_id = Au_open THEN 1 ELSE 0 END ) AS grand_slams_count
  FROM Players CROSS JOIN Championships GROUP BY player_id, player_name ) T
WHERE grand_slams_count > 0


-- 另外还有一种做法就比较神奇了……
SELECT player_id,player_name,
SUM(player_id=Wimbledon)+SUM(player_id=Fr_open)+SUM(player_id=US_open)+SUM(player_id=Au_open)
as grand_slams_count
FROM Players
JOIN Championships
ON player_id=Wimbledon or player_id=Fr_open or player_id=US_open or player_id=Au_open
GROUP BY player_id;