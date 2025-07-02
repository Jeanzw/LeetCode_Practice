# Write your MySQL query statement below
with cte as
(select
a.employee_id,
a.name,
b.review_date,
b.rating,
count(review_id) over (partition by a.employee_id) as cnt,
row_number() over (partition by a.employee_id order by review_date desc) as rnk,
lead(rating) over (partition by a.employee_id order by review_date desc) as last_score,
lead(rating,2) over (partition by a.employee_id order by review_date desc) as last_2_score
from employees a
join performance_reviews b on a.employee_id = b.employee_id)

select
employee_id, name, rating - last_2_score as improvement_score
from cte
where cnt >= 3 and rnk = 1 and rating > last_score and last_score > last_2_score
order by 3 desc, 2

-------------------

-- Python
import pandas as pd

def find_consistently_improving_employees(employees: pd.DataFrame, performance_reviews: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(employees,performance_reviews, on = 'employee_id')
    merge.sort_values(['employee_id','review_date'], ascending = [1,0], inplace = True)
    merge['cnt'] = merge.groupby(['employee_id']).review_id.transform('nunique')
    merge['rnk'] = merge.groupby(['employee_id']).review_date.transform('rank', ascending = False)
    merge['last_score'] = merge.groupby(['employee_id']).rating.shift(-1)
    merge['last_2score'] = merge.groupby(['employee_id']).rating.shift(-2)
    
    merge = merge[(merge['cnt'] >= 3) & (merge['rating'] > merge['last_score']) & (merge['last_score'] > merge['last_2score']) & (merge['rnk'] == 1)]
    merge['improvement_score'] = merge['rating'] - merge['last_2score']
    return merge[['employee_id','name','improvement_score']].sort_values(['improvement_score','name'], ascending = [0,1])