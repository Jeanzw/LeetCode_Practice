with summary as
(select 
    customer_id, 
    transaction_date, 
    transaction_id, 
    row_number() over (partition by customer_id order by transaction_date desc) as rnk
from Transactions)
, bridge as
(select *, dateadd(day, rnk,transaction_date) as bridge from summary)
, cal as
(select 
    customer_id, 
    bridge, 
    count(distinct transaction_id) as total_trans,
    dense_rank() over (order by count(distinct transaction_id) desc) as rnk
from bridge
group by customer_id, bridge)

select customer_id from cal where rnk = 1 order by 1