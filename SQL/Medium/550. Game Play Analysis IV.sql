-- N次做之后的方式
-- 我们先找出最小的event date
-- 然后将其和原表join起来，找出
with first_login as
(select player_id, min(event_date) as login from Activity group by 1)

select 
round(sum(case when datediff(a.event_date,b.login) = 1 then 1 else 0 end)
/
count(distinct a.player_id),2) as fraction
from Activity a
 left join first_login b 
 on a.player_id = b.player_id 





-- 下面这一个代码是我自己写的，相当于我们先把各个player_id的最小日期求出来，然后找和最小日期相差天数只有一天的日期和player_id，计算出来当做分子top，然后再计算有多少个player_id当做分母，然后在最开头用分子除以分母
with firstlogin as
(select player_id, min(event_date) as first_login 
from Activity group by 1)
,top as
(select count(distinct a.player_id) as top from Activity a 
inner join firstlogin f on a.player_id = f.player_id and datediff(a.event_date,first_login) = 1)
,bottom as 
(select count(distinct player_id) as bottom from Activity)

select round(top/bottom,2) as fraction from top,bottom


-- 我们现在把上面的这一个解法做一个拆解如此便于我们更好理解该题：
-- 第一步：
-- 由于我们想要知道的事在第一次log之后的第二天是否有log，那么我们先找出每个player的第一天登录的时间
select player_id,min(event_date) as min_date from Activity
group by player_id
-- 在我们找到第一次登录的事件之后，我们需要去找有哪些player第二天也登陆了，而这些玩家的数量就是我们的分子
-- 为了找到这些player我们当然可以用left join，但是既然我们只要找到交集，那么直接用inner就好了,对于我们的例子，输出的是1，这个是正确的
select count(distinct a.player_id) as top from Activity a inner join
(select player_id,min(event_date) as min_date from Activity
group by player_id)b
on a.player_id = b.player_id and a.event_date - 1 = b.min_date
-- 而当我们找到分子之后，我们接下来要来找分母了，分母其实非常简单，就是直接计算player的数量就好了,于是就构成了我们的答案
select round(top/bottom,2) as fraction from

(
select count(distinct a.player_id) as top from Activity a inner join
(select player_id,min(event_date) as min_date from Activity
group by player_id)b
on a.player_id = b.player_id and a.event_date - 1 = b.min_date
    ) c,

(select count(distinct player_id) as bottom from Activity)d




-- 我觉得上面的答案真的太复杂了……
-- 这道题其实就是先找最小日期，然后将最小日期和原表相连，保证playerid一致同时日期相差1天即可
-- 连得上的就是满足条件的，连不上的就是不满足条件的
with min_day as
(select player_id, min(event_date) as min_day from Activity group by 1)

select
round(count(distinct b.player_id)/count(distinct a.player_id),2) as fraction
from min_day a
left join Activity b on datediff(b.event_date,a.min_day) = 1 and a.player_id = b.player_id


-- Python
import pandas as pd

def gameplay_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Find the first login date for each player
    first_login = activity.groupby('player_id')['event_date'].min().reset_index()
    
    # Step 2: Create a new column for the day before each event_date in the original DataFrame
    activity['day_before_event'] = activity['event_date'] - pd.to_timedelta(1, unit='D')
    
    # Step 3: Merge the dataframes to find rows where player logged in a day after their first login
    merged_df = activity.merge(first_login, on='player_id', suffixes=('_actual', '_first'))
    
    # Step 4: Find the rows where the actual event date matches the day after the first login date
    consecutive_login = merged_df[merged_df['day_before_event'] == merged_df['event_date_first']]
    
    # Step 5: Calculate the fraction of players that logged in again on the day after their first login
    fraction = round(consecutive_login['player_id'].nunique() / activity['player_id'].nunique(), 2)
    
    # Step 6: Create a dataframe to hold the output
    output_df = pd.DataFrame({'fraction': [fraction]})
    
    return output_df