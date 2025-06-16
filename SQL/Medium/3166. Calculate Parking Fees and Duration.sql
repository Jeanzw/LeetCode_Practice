with cte as
(select
car_id,lot_id,
sum(fee_paid) as total_fee_paid,
(sum(timestampdiff(minute,entry_time,exit_time))/60) as hours,
rank() over (partition by car_id order by sum(timestampdiff(minute,entry_time,exit_time)) desc) as most_time_lot
from ParkingTransactions 
group by 1,2)

select 
car_id,
sum(total_fee_paid) as total_fee_paid,
round(sum(total_fee_paid)/sum(hours),2) as avg_hourly_fee,
max(case when most_time_lot = 1 then lot_id end) as most_time_lot
from cte
group by 1
order by 1

-----------------------------------------------

-- Python
import pandas as pd

def calculate_fees_and_duration(parking_transactions: pd.DataFrame) -> pd.DataFrame:
    parking_transactions['hours'] = (parking_transactions['exit_time'] - parking_transactions['entry_time']).dt.total_seconds()/3600
    parking_transactions = parking_transactions.groupby(['car_id','lot_id'],as_index = False).agg(
        total_fee = ('fee_paid','sum'),
        total_hours = ('hours','sum')
    )
    parking_transactions['rnk'] = parking_transactions.groupby(['car_id']).total_hours.rank(ascending = False)

    summary = parking_transactions.groupby(['car_id'],as_index = False).agg(
        total_fee_paid = ('total_fee','sum'),
        total_hours = ('total_hours','sum')
    )
    summary['avg_hourly_fee'] = round(summary['total_fee_paid']/summary['total_hours'],2)
    
    most_used_lot = parking_transactions[parking_transactions['rnk'] == 1]
    res = pd.merge(summary,most_used_lot, on = 'car_id')[['car_id','total_fee_paid','avg_hourly_fee','lot_id']]
    
    return res.rename(columns = {'lot_id':'most_time_lot'}).sort_values('car_id')

-----------------------------------------------

-- 找到最常用的lot不一定要用rnk，也可以用head
import pandas as pd

def calculate_fees_and_duration(parking_transactions: pd.DataFrame) -> pd.DataFrame:
    parking_transactions['total_hour'] = (parking_transactions['exit_time'] - parking_transactions['entry_time']).dt.total_seconds()/3600
    parking_transactions = parking_transactions.groupby(['car_id','lot_id'], as_index = False).agg(
        total_hour = ('total_hour','sum'),
        fee_paid = ('fee_paid','sum')
    )

    most_time_lot = parking_transactions.sort_values(['car_id','total_hour'], ascending = [1,0]).groupby(['car_id']).head(1)
    
    summary = parking_transactions.groupby(['car_id'], as_index = False).agg(
        total_hour = ('total_hour','sum'),
        total_fee_paid = ('fee_paid','sum')        
    )
    summary['avg_hourly_fee'] = round(summary['total_fee_paid']/summary['total_hour'],2)

    res = pd.merge(summary,most_time_lot, on = 'car_id', how = 'left')
    return res[['car_id','total_fee_paid','avg_hourly_fee','lot_id']].rename(columns = {'lot_id':'most_time_lot'}).sort_values('car_id')