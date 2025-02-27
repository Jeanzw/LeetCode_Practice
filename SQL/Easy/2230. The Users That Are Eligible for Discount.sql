CREATE PROCEDURE getUserIDs(startDate DATE, endDate DATE, minAmount INT)
BEGIN
	# Write your MySQL query statement below.
	select distinct user_id from Purchases
    where time_stamp between startDate and endDate
    -- 我们这里是不能改成date(time_stamp) between startDate and endDate
    -- 因为题目中说了：To convert the dates to times, both dates should be considered as the start of the day
    and amount >= minAmount
    order by 1;
END

--------------------------

import pandas as pd
from datetime import datetime

def find_valid_users(purchases: pd.DataFrame, start_date: datetime, end_date: datetime, min_amount: int) -> pd.DataFrame:
    purchases = purchases[(purchases['time_stamp'] >= start_date) & (purchases['time_stamp'] <= end_date) & (purchases['amount'] >= min_amount)]
    purchases = purchases[['user_id']].drop_duplicates()
    return purchases.sort_values('user_id')