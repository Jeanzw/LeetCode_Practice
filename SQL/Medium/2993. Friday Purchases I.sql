select
(week(purchase_date) - week('2023-11-01') + 1) as week_of_month,
purchase_date,
sum(amount_spend) as total_amount
from Purchases
where month(purchase_date) = 11 and year(purchase_date) = 2023
and weekday(purchase_date) = 4
group by 1,2
order by 1