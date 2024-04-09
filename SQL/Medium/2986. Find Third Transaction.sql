with summary as
(select
*,
lag(spend) over (partition by user_id order by transaction_date) as previous,
lag(spend,2) over (partition by user_id order by transaction_date) as previous_2,
rank() over (partition by user_id order by transaction_date) as rnk
from Transactions)

select user_id,spend as third_transaction_spend, transaction_date as third_transaction_date
from summary
where rnk = 3 and spend > previous and spend > previous_2
order by 1