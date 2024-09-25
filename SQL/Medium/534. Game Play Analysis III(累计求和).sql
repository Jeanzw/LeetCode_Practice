-- 一个和rank ()一个级别的window function： sum() over ()

select player_id, event_date, 
sum(games_played) over (partition by player_id order by event_date) as games_played_so_far 
from Activity   


-- 如果不用sum() over那么就是常规解法：
SELECT a1.player_id, a1.event_date,
SUM(a2.games_played) AS games_played_so_far
FROM activity a1, activity a2
WHERE a1.player_id = a2.player_id
AND a1.event_date >=a2.event_date
GROUP BY a1.player_id, a1.event_date
ORDER BY a1.player_id, a1.event_date;
/*
对上面的解释如下：
我们的input如下
{"headers":{"Activity":["player_id","device_id","event_date","games_played"]},
"rows":{"Activity":    [[1,2,"2016-03-01",5],
                        [1,2,"2016-05-02",6],
                        [1,3,"2017-06-25",1],
                        [3,1,"2016-03-02",0],
                        [3,4,"2018-07-03",5]]}}

当我们进行第一步操作
SELECT *
FROM activity a1, activity a2
结果如下，相当于每条数据两两配对，应该有5 x 5 = 25条数据
{"headers": ["player_id", "device_id", "event_date", "games_played", "player_id", "device_id", "event_date", "games_played"], 
 "values": [[3, 4, "2018-07-03", 5, 1, 2, "2016-03-01", 5], 
            [3, 1, "2016-03-02", 0, 1, 2, "2016-03-01", 5], 
            [1, 3, "2017-06-25", 1, 1, 2, "2016-03-01", 5], 
            [1, 2, "2016-05-02", 6, 1, 2, "2016-03-01", 5], 
            [1, 2, "2016-03-01", 5, 1, 2, "2016-03-01", 5], 
            [3, 4, "2018-07-03", 5, 1, 2, "2016-05-02", 6], 
            [3, 1, "2016-03-02", 0, 1, 2, "2016-05-02", 6], 
            [1, 3, "2017-06-25", 1, 1, 2, "2016-05-02", 6], 
            [1, 2, "2016-05-02", 6, 1, 2, "2016-05-02", 6], 
            [1, 2, "2016-03-01", 5, 1, 2, "2016-05-02", 6], 
            [3, 4, "2018-07-03", 5, 1, 3, "2017-06-25", 1], 
            [3, 1, "2016-03-02", 0, 1, 3, "2017-06-25", 1], 
            [1, 3, "2017-06-25", 1, 1, 3, "2017-06-25", 1], 
            [1, 2, "2016-05-02", 6, 1, 3, "2017-06-25", 1], 
            [1, 2, "2016-03-01", 5, 1, 3, "2017-06-25", 1], 
            [3, 4, "2018-07-03", 5, 3, 1, "2016-03-02", 0], 
            [3, 1, "2016-03-02", 0, 3, 1, "2016-03-02", 0], 
            [1, 3, "2017-06-25", 1, 3, 1, "2016-03-02", 0],...

之后进行第二步操作，加上where条件
SELECT *
FROM activity a1, activity a2
WHERE a1.player_id = a2.player_id
AND a1.event_date >=a2.event_date
结果是
{"headers": ["player_id", "device_id", "event_date", "games_played", "player_id", "device_id", "event_date", "games_played"], 
 "values": [[1, 3, "2017-06-25", 1, 1, 2, "2016-03-01", 5],
            [1, 2, "2016-05-02", 6, 1, 2, "2016-03-01", 5], 
            [1, 2, "2016-03-01", 5, 1, 2, "2016-03-01", 5], 
            [1, 3, "2017-06-25", 1, 1, 2, "2016-05-02", 6], 
            [1, 2, "2016-05-02", 6, 1, 2, "2016-05-02", 6], 
            [1, 3, "2017-06-25", 1, 1, 3, "2017-06-25", 1], 
            [3, 4, "2018-07-03", 5, 3, 1, "2016-03-02", 0], 
            [3, 1, "2016-03-02", 0, 3, 1, "2016-03-02", 0], 
            [3, 4, "2018-07-03", 5, 3, 4, "2018-07-03", 5]]}
那么其实我们观察上面的数据可以知道，比如说对于player_id = 1的情况
他最小的event date是"2016-03-01"那么对应的只有一条数据
而第二小的event date是"2016-05-02"那么对应的有两条数据额"2016-05-02"以及"2016-03-01"
而我们在2016-05-02这个时间点，就是要拿"2016-05-02"以及"2016-03-01"的games_played的总和
所以基于上面的分析，我们其实只要对每个event date，然后把右边的games_played求和即可
总的query如下：
SELECT a1.player_id, a1.event_date,
SUM(a2.games_played) AS games_played_so_far
FROM activity a1, activity a2
WHERE a1.player_id = a2.player_id
AND a1.event_date >=a2.event_date
GROUP BY a1.player_id, a1.event_date


*/




-- Python
import pandas as pd

def gameplay_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    activity = activity.sort_values(['player_id','event_date'])
    activity['games_played_so_far'] = activity.groupby(['player_id']).games_played.cumsum()
    return activity[['player_id','event_date','games_played_so_far']]
