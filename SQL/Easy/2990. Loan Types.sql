select user_id from Loans
where loan_type in ('Mortgage','Refinance')
group by 1
having count(distinct loan_type) = 2
order by 1


-- Python
import pandas as pd

def loan_types(loans: pd.DataFrame) -> pd.DataFrame:
    loans = loans.query("loan_type == 'Mortgage' or loan_type == 'Refinance' ")
    loans = loans.groupby(['user_id'],as_index = False).loan_type.nunique()
    return loans.query("loan_type == 2")[['user_id']].sort_values('user_id')