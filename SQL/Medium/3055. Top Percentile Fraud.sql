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




-- Python
import pandas as pd

def top_percentile_fraud(fraud: pd.DataFrame) -> pd.DataFrame:
    fraud['rnk'] = fraud.groupby(['state']).fraud_score.rank(method = 'dense', pct = True)
    fraud = fraud.query("rnk >= 0.95")
    return fraud[['policy_id','state','fraud_score']].sort_values(['state','fraud_score','policy_id'], ascending = [1,0,1])