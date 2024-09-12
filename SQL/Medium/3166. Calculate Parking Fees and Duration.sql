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



-- Python
import pandas as pd

def calculate_fees_and_duration(parking_transactions: pd.DataFrame) -> pd.DataFrame:
    parking_transactions['duration'] = (parking_transactions['exit_time'] - parking_transactions['entry_time']).dt.total_seconds()
    car_lot = parking_transactions.groupby(['car_id','lot_id'],as_index = False).agg(
        total_fee_paid = ('fee_paid','sum'),
        duration = ('duration','sum')
    )
    car_lot['rnk'] = car_lot.groupby('car_id').duration.rank(ascending = False)

    most_time_lot = car_lot.query("rnk == 1")[['car_id','lot_id']]
    summary = car_lot.groupby(['car_id'], as_index = False).agg(
        total_fee_paid = ('total_fee_paid','sum'),
        duration = ('duration','sum')
    )
    summary['duration'] = round(summary['duration']/3600,2)
    summary['avg_hourly_fee'] = round(summary['total_fee_paid']/summary['duration'],2)

    result = pd.merge(summary,most_time_lot,on = 'car_id')
    return result[['car_id','total_fee_paid','avg_hourly_fee','lot_id']].rename(columns = {'lot_id':'most_time_lot'}).sort_values('car_id')