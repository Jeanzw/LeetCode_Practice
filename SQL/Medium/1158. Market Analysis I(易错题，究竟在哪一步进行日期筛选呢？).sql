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



-- 筛选 Where，比如说要从下面筛出2019年的订单，涉及的知识点
-- 1. query -> 筛选
-- 2. dt.year -> 选取某个固定年份

Orders
| order_id | order_date | item_id | buyer_id | seller_id |
| -------- | ---------- | ------- | -------- | --------- |
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2018-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2018-08-04 | 1       | 4        | 2         |
| 5        | 2018-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |

orders.query("order_date.dt.year == 2019")

这里 dt.year就是按照年份选取，"order_date.dt.year == 2019" 就是让order_date按照年份选取等于2019。
那么抽出来的就是
| order_id | order_date | item_id | buyer_id | seller_id |
| -------- | ---------- | ------- | -------- | --------- |
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2018-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
如果我们改成"order_date.dt.day == 4" 呢么就是让order_date按照日来选取，选取日期为4的行数
| order_id | order_date | item_id | buyer_id | seller_id |
| -------- | ---------- | ------- | -------- | --------- |
| 4        | 2018-08-04 | 1       | 4        | 2         |
| 5        | 2018-08-04 | 1       | 3        | 4         |
然后用query来做筛选，从而将orders这张表按照年份=2019年来进行筛选



-- Merge 
-- a.merge(要连接的表b，left_on ="a表中用来连接的列"，right_on = "b表中用来连接的列", how = "如何连接")
-- 或者 pd.merge(表a，表b，left_on ="a表中用来连接的列"，right_on = "b表中用来连接的列",how = "如何连接")

-- how{‘left’, ‘right’, ‘outer’, ‘inner’, ‘cross’}，默认是inner


-- Group By
-- 表a.groupby(["想要Groupby的列A"，"想要Groupby的列B",...]).想要对某一列计数.count()

-- 这里相当于你要几列就group by 多少，因为之后出来的形式是：
    -- 想要Groupby的列A    想要Groupby的列B      想要对某一列计数
-- 这里的count()也可以改成sum(),mean()



-- Rename
rename(columns={"某个已存的列": "改名", "某个已存的列": "改名"})