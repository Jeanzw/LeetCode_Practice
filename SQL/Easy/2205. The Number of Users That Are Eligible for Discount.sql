CREATE FUNCTION getUserIDs(startDate DATE, endDate DATE, minAmount INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select count(distinct user_id) as user_cnt
      from Purchases
      where time_stamp between startDate and endDate and amount >= minAmount
  );
END

-----------------

import pandas as pd
from datetime import datetime

def count_valid_users(purchases: pd.DataFrame, start_date: datetime, end_date: datetime, min_amount: int) -> pd.DataFrame:
    promote = purchases[(purchases['time_stamp'] >= start_date) & (purchases['time_stamp'] <= end_date) & (purchases['amount'] >= min_amount)]
    user_cnt = promote.user_id.nunique()
    return pd.DataFrame({'user_cnt':[user_cnt]})