select user_id as buyer_id,join_date,count(order_id) as orders_in_2019 from Users u
left join Orders o on
u.user_id = o.buyer_id
and year(order_date) = '2019'  
/*
我们需要在join的时候就进行日期筛选，不然如果用where进行日期筛选，那么没有订单的buyer_id = 3和4的人就会被删除该行
*/
group by user_id


-- 或者根本不需要考虑什么时候进行筛选的问题
with 2019_order as
(select buyer_id, count(order_id) as order_num from Orders
where year(order_date) = 2019
group by 1)
-- 先用一个cte将2019年的订单数给抽出来，然后再进行join

select user_id as buyer_id, join_date, ifnull(order_num,0) as orders_in_2019 from Users u
left join 2019_order o on u.user_id = o.buyer_id


-- Python

import pandas as pd

def market_analysis(
    users: pd.DataFrame, orders: pd.DataFrame, items: pd.DataFrame
) -> pd.DataFrame:

    # Step 1: Filter the orders dataframe to only include orders from the year 2019.
    df = orders.query("order_date.dt.year==2019").merge(
        # Step 2: Merge the filtered orders with the users dataframe on buyer_id and user_id.
        users,
        left_on="buyer_id",
        right_on="user_id",
        how="right",
    )

    # Step 3: Group the merged dataframe by user_id and join_date, then count the number of items (orders) for each user.
    result = df.groupby(["user_id", "join_date"]).item_id.count()

    # Step 4: Format the output by resetting the index and renaming the columns for clarity.
    return result.reset_index().rename(
        columns={"user_id": "buyer_id", "item_id": "orders_in_2019"}
    )