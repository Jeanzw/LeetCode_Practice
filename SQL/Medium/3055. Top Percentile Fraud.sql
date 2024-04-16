with process as
(select
*,
percent_rank() over (partition by state order by fraud_score desc) as pr
from Fraud)

select 
policy_id,
state,
fraud_score
from process
where pr <= 0.05
order by 2, 3 desc, 1

