select a.Id from Weather a, Weather b
where Datediff(a.RecordDate, b.RecordDate) = 1 
and a.Temperature>b.Temperature
-- mysql的datediff的应用：
-- https://www.w3school.com.cn/sql/func_datediff_mysql.asp



-- 下面那种解法的解释错了，不是因为不能用left join，而是因为date function用错了
-- 我们不应该用Id来做定位，因为可能存在下面那个例子就是虽然12-16是12-15的第二天，但是12-16的Id比12-15要小的情况
-- 我们唯一能够比较昨天和今年的就只有recordDate
-- 那么在这种情况下当然是可以用left join的
select a.Id from Weather a
left join Weather b 
on datediff(a.recordDate,b.recordDate) = 1 
where a.Temperature > b. Temperature



-- 这里是不能用left join的，因为这样其实当第一天的温度是最大的时候：
-- {"headers": {"Weather": ["Id", "RecordDate", "Temperature"]}, 
--   "rows": {"Weather": [[1, "2000-12-16", 3], [2, "2000-12-15", -1]]}}
-- 那么其实得出的结果会是一个[],但是我们希望在这种情况下返回第一个id
select a.Id from Weather a
left join Weather b 
  on a.Id -1 = b.Id 
where a.Temperature > b.Temperature


-- 其实这种题，当我们只需要考虑存在的而不需要考虑不存在的，那么使用join其实会好很多
select 
distinct a.id 
from Weather a
join Weather b on datediff(a.recordDate,b.recordDate) = 1 and a.Temperature > b.Temperature


-- 用python写
import pandas as pd

def rising_temperature(weather: pd.DataFrame) -> pd.DataFrame:
    # Ensure the 'recordDate' column is a datetime type
    weather['recordDate'] = pd.to_datetime(weather['recordDate'])
    
    # Create a copy of the weather DataFrame with a 1 day shift 
    weather_shifted = weather.copy()
    weather_shifted['recordDate'] = weather_shifted['recordDate'] + pd.to_timedelta(1, unit='D')
    
    # Merging the DataFrames on the 'recordDate' column to find consecutive dates
    merged_df = pd.merge(weather, weather_shifted, on='recordDate', suffixes=('_today', '_yesterday'))
    
    # Finding rows where the temperature is greater on the current day compared to the previous day
    result = merged_df[merged_df['temperature_today'] > merged_df['temperature_yesterday']][['id_today']].rename(columns={'id_today': 'Id'})
    
    return result
