with ny as
(select count(case when score >= 90 then student_id end) as ny from NewYork)
, cali as
(select count(case when score >= 90 then student_id end) as cali from California)

select
case when (select ny from ny) > (select cali from cali) then 'New York University'
     when (select ny from ny) < (select cali from cali) then 'California University'
     else 'No Winner' end as winner

----------------------------------

-- 或者不用cte直接一条写下来
select
case when (select count(distinct student_id) from NewYork where score >= 90) > (select count(distinct student_id) from California where score >= 90) then 'New York University'
     when (select count(distinct student_id) from NewYork where score >= 90) < (select count(distinct student_id) from California where score >= 90) then 'California University'  
     else 'No Winner' end as winner

----------------------------------

--  Python
import pandas as pd

def find_winner(new_york: pd.DataFrame, california: pd.DataFrame) -> pd.DataFrame:
    new_york = new_york[new_york['score'] >= 90].student_id.nunique()
    california = california[california['score'] >= 90].student_id.nunique()
    if new_york > california:
        winner = 'New York University'
    elif new_york < california:
        winner = 'California University'
    else:
        winner = 'No Winner'
    return pd.DataFrame({'winner':[winner]})
