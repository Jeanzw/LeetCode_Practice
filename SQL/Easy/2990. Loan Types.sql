select user_id from Loans
where loan_type in ('Mortgage','Refinance')
group by 1
having count(distinct loan_type) = 2
order by 1

--------------------------------

-- 或者这么做：
select
distinct a.user_id
from Loans a
join Loans b on a.user_id = b.user_id
where a.loan_type = 'Mortgage' and b.loan_type = 'Refinance'
order by 1

--------------------------------

-- Python
import pandas as pd

def loan_types(loans: pd.DataFrame) -> pd.DataFrame:
    loans = loans.query("loan_type == 'Mortgage' or loan_type == 'Refinance' ")
    loans = loans.groupby(['user_id'],as_index = False).loan_type.nunique()
    return loans.query("loan_type == 2")[['user_id']].sort_values('user_id')

--------------------------------

-- 另外的做法：
import pandas as pd

def loan_types(loans: pd.DataFrame) -> pd.DataFrame:
    Mortgage = loans[loans['loan_type'] == 'Mortgage']
    Refinance = loans[loans['loan_type'] == 'Refinance']
    merge = pd.merge(Mortgage,Refinance,on = 'user_id')
    return merge[['user_id']].drop_duplicates().sort_values('user_id')