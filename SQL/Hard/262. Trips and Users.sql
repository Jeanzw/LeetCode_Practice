-- 知识点：
-- 1. 保留几位小数round(xxx,2)
select
    Request_at as Day,
    round(count(distinct case when Status != 'completed' then Id else null end)
    /
    count(distinct Id),2) as 'Cancellation Rate'
from Trips t
join Users u1 on t.Client_Id = u1.Users_Id and u1.Banned = 'No' 
join Users u2 on t.Driver_Id = u2.Users_Id and u2.Banned = 'No' 
where Request_at between "2013-10-01" and "2013-10-03"
group by 1



-- 其实也可以不用join来筛选unbanned的内容，直接用where和not in来进行筛选
-- 下面是我后来写的
select Request_at as Day,
ifnull(round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2),0.00) as 'Cancellation Rate'
from Trips

where Client_Id in (select Users_Id from Users where Banned != 'Yes')
and Driver_Id in (select Users_Id from Users where Banned != 'Yes')
and Request_at BETWEEN '2013-10-01' AND '2013-10-03'

group by Request_at

-- 这里我们需要注意的是一定要是case when Status != 'completed' then 1 else 0 end，因为calcelled by可以是client也可以是driver，如果用calcelled那么就会比较麻烦






-- 下面我开始用cte来写，逻辑感觉比较清楚
with ban as
(select Users_Id from Users where Banned = 'Yes')
-- 上面这个ban就是把已经被限制的userid给取出来
, eligible_case as
(select * from Trips
where Client_Id not in (select Users_Id from ban)
 and Driver_Id not in (select Users_Id from ban)
 and Request_at between '2013-10-01' and '2013-10-03'
)
-- eligible case找出符合要求的数据

select 
Request_at as Day,
round(sum(case when Status != 'completed' then 1 else 0 end)/count(*),2) as 'Cancellation Rate'
from eligible_case





-- Python
import pandas as pd

def trips_and_users(trips: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Initial Check
    if trips.empty or users.empty:
        return pd.DataFrame(columns=["Day", "Cancellation Rate"])

    # Step 2: Date-based Filtering
    filtered_trips = trips[trips["request_at"].between("2013-10-01", "2013-10-03")]

    # Step 3: Merge with Non-Banned Clients
    trips_with_clients = filtered_trips.merge(
        users.loc[users["banned"] == "No", ["users_id"]],
        left_on="client_id",
        right_on="users_id",
        how="inner",
    )

    # Step 4: Merge with Non-Banned Drivers
    trip_status = trips_with_clients.merge(
        users.loc[users["banned"] == "No", ["users_id"]],
        left_on="driver_id",
        right_on="users_id",
        how="inner",
    )

    # Step 5: Calculate Day-wise Cancellation Rate
    result = trip_status.groupby("request_at").apply(
        lambda group: pd.Series(
            {"Cancellation Rate": round(
                 (group["status"] != "completed").sum() / len(group), 2
                 )
             }
        )
    )

    # Step 6: Format and Return the Result
    if result.empty:
        return pd.DataFrame(columns=["Day", "Cancellation Rate"])
    else:
        return result.reset_index().rename(columns={"request_at": "Day"})
