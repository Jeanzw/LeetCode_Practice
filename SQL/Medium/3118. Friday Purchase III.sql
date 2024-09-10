with recursive week_of_month as
(select 1 as week_of_month
union all
select week_of_month + 1 as week_of_month from week_of_month
where week_of_month< 4
)
, membership as
(select 'Premium' as membership
union all
select 'VIP' as membership
)
, framework as
(select * from week_of_month,membership)
, summary as
(select
a.user_id,
week(purchase_date) - week('2023-11-01') + 1 as week_of_month,
b.membership,
sum(amount_spend) as amount_spend
from Purchases a
left join Users b on a.user_id = b.user_id
where membership in ('Premium','VIP')
and weekday(purchase_date) = 4
group by 1,2,3
)

select
a.week_of_month,
a.membership,
ifnull(sum(amount_spend),0) as total_amount
from framework a
left join summary b on a.membership = b.membership and a.week_of_month = b.week_of_month
group by 1,2
order by 1,2


-- 第二次做，更加清楚明了：
with recursive date_frame as
(select '2023-11-03' as week_day, 1 as week_of_month 
union all
select (week_day + interval '7' day) as week_day, (week_of_month + 1) as week_of_month  from date_frame
where week_of_month <= 3
)
,membership as
(select 'Premium' as membership union select 'VIP' as membership)
, frame as
(select * from date_frame,membership)

select 
a.week_of_month,
a.membership,
ifnull(sum(c.amount_spend),0) as total_amount
from frame a
left join Users b on a.membership = b.membership
left join Purchases c on b.user_id = c.user_id and a.week_day = c.purchase_date
group by 1,2
order by 1,2


-- Python
import pandas as pd

def friday_purchases(purchases: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    week_of_month = pd.DataFrame({'week_of_month':[1,2,3,4]})
    membership = pd.DataFrame({'membership':['Premium','VIP']})
    cross = pd.merge(week_of_month,membership, how = 'cross')

    purchases['weekday'] = purchases['purchase_date'].dt.weekday
    purchases['week_of_month'] = purchases['purchase_date'].dt.isocalendar().week - 43
    purchases = purchases.query("weekday == 4")
    purchases_users = pd.merge(purchases,users, on = 'user_id').groupby(['week_of_month','membership'], as_index = False).amount_spend.sum()

    result = pd.merge(cross,purchases_users, on = ['week_of_month','membership'], how = 'left')
    return result.rename(columns = {'amount_spend':'total_amount'}).sort_values(['week_of_month','membership']).fillna(0)