with rawdata as
(select caller_id as id1, recipient_id as id2,call_time from Calls
union 
 select recipient_id as id1, caller_id as id2,call_time from Calls
)
, rnk as
(select * from
(select
id1,
id2,
date(call_time) as call_day,  
-- 我们之所以在这里要找到call time对应的日子是因为题目中说了：whose first and last calls on any day were with the same person
-- 也就是说只要某一天是同一个人就可以了
-- 这也就导致了我们之后的rank的partition by也是要以id1以及call day作为划分点
call_time,
rank() over (partition by id1,date(call_time) order by call_time) as rnk,
rank() over (partition by id1,date(call_time) order by call_time desc) as rnk_desc
from rawdata)tmp
where rnk = 1 or rnk_desc = 1
-- 而后我们只选取第一个或者最后一个打电话的信息
)


select 
distinct r1.id1 as user_id
from rnk r1
join rnk r2 on 
(r1.id1 = r2.id1 and r1.id2 = r2.id2 and r1.call_time != r2.call_time and r1.call_day = r2.call_day) 
-- 我们第一个条件就是保证对应的id1和id2都是一样的，同时时间不一样并且保证是同一天
or (r1.rnk  = 1 and r1.rnk_desc = 1 and r1.call_day = r2.call_day)
-- 我们第二个条件是为了只打了一个电话的人设计的，对于这波人，rnk以及rnk desc都是一样的就是1，但是我们要保证是同一天打的电话



-- 下面是别人做的
-- 和我上面做的没有什么很大不同
-- 最大不同就是最后求result的时候，我是用了一个join来查询
-- 但是此人是直接靠计算recipient_id的数量来查询，如果是1个，那么就说明要不然就是只打了一次电弧要不然就是最早最晚都是一个人
WITH CTE AS (
                SELECT caller_id AS user_id, call_time, recipient_id FROM Calls
                UNION 
                SELECT recipient_id AS user_id, call_time, caller_id AS recipient_id FROM Calls
            ),

CTE1 AS (
        SELECT 
        user_id,
        recipient_id,
        DATE(call_time) AS DAY,
        DENSE_RANK() OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time ASC) AS RN,
        DENSE_RANK() OVER(PARTITION BY user_id, DATE(call_time) ORDER BY call_time DESC) AS RK
        FROM CTE
        )

SELECT DISTINCT user_id
FROM CTE1
WHERE RN = 1 OR RK = 1
GROUP BY user_id, DAY
HAVING COUNT(DISTINCT recipient_id) = 1



-- 或者下面这种方法，用min和max找到某一天第一个和最后一个电话
with framework as
(select caller_id as person1,recipient_id as person2,call_time from Calls
union
select recipient_id as person1,caller_id as person2,call_time from Calls)
, first_last_call as
(select person1,date(call_time) as call_day, min(call_time) as frist_call, max(call_time) as last_call from framework group by 1,2)

select
distinct a.person1 as user_id
from framework a
inner join first_last_call b on a.person1 = b.person1 and call_time in (frist_call,last_call)
group by a.person1, a.person2
having count(*) = 2
union
select 
person1 as user_id
from first_last_call 
where frist_call = last_call



-- Python
import pandas as pd

def same_day_calls(calls: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Create a unified view of calls
    # Each call is represented twice, from both caller's and recipient's perspectives.
    unified_calls = pd.concat(
        [
            calls,
            calls.rename(
                columns={"caller_id": "recipient_id", "recipient_id": "caller_id"}
            ),
        ],
        ignore_index=True,
    )

    # Step 2: Extract the date part from call_time to identify the call day
    unified_calls["call_day"] = unified_calls["call_time"].dt.date

    # Step 3: Identify the first (earliest) and last (latest) calls of each day for each user
    # Group by call_day and caller_id, then find the index of the min/max call_time
    first_call_indices = unified_calls.groupby(["call_day", "caller_id"])[
        "call_time"
    ].idxmin()
    last_call_indices = unified_calls.groupby(["call_day", "caller_id"])[
        "call_time"
    ].idxmax()

    first_calls = unified_calls.loc[first_call_indices]
    last_calls = unified_calls.loc[last_call_indices]

    # Step 4: Merge first and last calls to find users whose first and last calls are with the same recipient
    merged_calls = first_calls.merge(
        last_calls, on=["caller_id", "recipient_id", "call_day"]
    )

    # Step 5: Prepare the final output
    # Select unique caller_id and rename to user_id
    result = (
        merged_calls[["caller_id"]]
        .rename(columns={"caller_id": "user_id"})
        .drop_duplicates()
    )

    return result
