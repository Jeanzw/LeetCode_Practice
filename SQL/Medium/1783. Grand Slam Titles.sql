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

---------------------------------

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

---------------------------------

-- 另外还有一种做法就比较神奇了……
SELECT player_id,player_name,
SUM(player_id=Wimbledon)+SUM(player_id=Fr_open)+SUM(player_id=US_open)+SUM(player_id=Au_open)
as grand_slams_count
FROM Players
JOIN Championships
ON player_id=Wimbledon or player_id=Fr_open or player_id=US_open or player_id=Au_open
GROUP BY player_id;

---------------------------------

-- Python
import pandas as pd

def grand_slam_titles(players: pd.DataFrame, championships: pd.DataFrame) -> pd.DataFrame:
    Wimbledon = championships[['Wimbledon']].rename(columns = {'Wimbledon':'player_id'})
    Fr_open = championships[['Fr_open']].rename(columns = {'Fr_open':'player_id'})
    US_open = championships[['US_open']].rename(columns = {'US_open':'player_id'})
    Au_open = championships[['Au_open']].rename(columns = {'Au_open':'player_id'})

    concat = pd.concat([Wimbledon,Fr_open,US_open,Au_open])

    merge = pd.merge(players,concat,on = 'player_id')
    res = merge.groupby(['player_id','player_name'],as_index = False).size()
    return res.rename(columns = {'size':'grand_slams_count'})