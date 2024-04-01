with cte as
(select 
*,
row_number() over (partition by emp_id order by salary desc) as rnk
from Salary)

select emp_id,firstname, lastname,salary,department_id
from cte where rnk = 1
order by 1



-- Python
def find_latest_salaries(salary: pd.DataFrame) -> pd.DataFrame:
    df = salary.sort_values(by = 'salary', ascending = False)
    df = df.drop_duplicates(subset = 'emp_id')
    return df.sort_values(by = 'emp_id')