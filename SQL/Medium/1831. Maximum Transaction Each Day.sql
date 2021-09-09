select transaction_id from
(select transaction_id,dense_rank() over (partition by date(day) order by amount desc) as rnk
from Transactions)tmp
where rnk = 1
order by 1