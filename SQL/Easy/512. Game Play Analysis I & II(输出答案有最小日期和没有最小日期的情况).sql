-- 511：输出答案有最小日期的情况
select player_id, min(event_date) as first_login from Activity
group by player_id

-- 512：输出答案没有最小日期的情况
select player_id, device_id from Activity
where (player_id,event_date) in 
--这里的where里面用一个双重索引其实是我要去找最小的event_date，由于题目说了(player_id,event_date)这这组合是primary key，所以我就用这两者的组合进行检索
(select player_id,min(event_date) as event_date from Activity
group by player_id)


-- 也可以直接用rank去做
with rnk as
(select 
    player_id, 
    device_id, 
    event_date,
    dense_rank() Over(partition by player_id order by event_date) as rnk
    from Activity
    )

select player_id, device_id from rnk where rnk = 1



-- Python
import pandas as pd

def game_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Find the index of the first login date for each player
    idx = activity.groupby('player_id')['event_date'].idxmin()
    
    # Step 2: Use the index to get the corresponding rows from the original DataFrame
    result = activity.loc[idx][['player_id', 'device_id']]

    # Step 3: Return the result
    return result