select
a.*,
datediff(min(c.test_date),min(b.test_date)) as recovery_time
from patients a
join covid_tests b on a.patient_id = b.patient_id and b.result = 'Positive'
join covid_tests c on a.patient_id = c.patient_id and c.result = 'Negative' and b.test_date <= c.test_date
group by 1,2,3
order by 4, 2

---------------------

-- Python
import pandas as pd

def find_covid_recovery_patients(patients: pd.DataFrame, covid_tests: pd.DataFrame) -> pd.DataFrame:
    positive = covid_tests[covid_tests['result'] == 'Positive']
    negative = covid_tests[covid_tests['result'] == 'Negative']
    merge = pd.merge(positive,negative, on = 'patient_id')
    merge = merge[merge['test_date_x'] <= merge['test_date_y']]
    merge = merge.groupby(['patient_id'],as_index = False).agg(
        min_positive = ('test_date_x','min'),
        min_negative = ('test_date_y','min')
    )
    merge['recovery_time'] = (pd.to_datetime(merge['min_negative']) - pd.to_datetime(merge['min_positive'])).dt.days
    
    res = pd.merge(patients, merge, on = 'patient_id')
    return res[['patient_id','patient_name','age','recovery_time']].sort_values(['recovery_time','patient_name'], ascending = [1,1])