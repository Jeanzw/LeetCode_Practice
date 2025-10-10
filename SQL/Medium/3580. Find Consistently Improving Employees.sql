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


-- 另外的做法
with cte as
(select *, row_number() over (partition by employee_id order by review_date desc) as rnk 
from performance_reviews)


select
a.employee_id,
a.name,
d.rating - b.rating as improvement_score
from employees a
join cte b on a.employee_id = b.employee_id and b.rnk = 3
join cte c on a.employee_id = c.employee_id and c.rnk = 2
join cte d on a.employee_id = d.employee_id and d.rnk = 1
where b.rating < c.rating and c.rating < d.rating
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


-- 另外的做法
import pandas as pd

def find_consistently_improving_employees(employees: pd.DataFrame, performance_reviews: pd.DataFrame) -> pd.DataFrame:
    performance_reviews['rnk'] = performance_reviews.groupby(['employee_id']).review_date.rank(ascending = False)
    first = performance_reviews[performance_reviews['rnk'] == 1]
    second = performance_reviews[performance_reviews['rnk'] == 2]
    third = performance_reviews[performance_reviews['rnk'] == 3]

    res = pd.merge(first, second, on = 'employee_id').merge(third, on = 'employee_id')
    res = res[(res['rating_x'] > res['rating_y']) & (res['rating_y'] > res['rating'])][['employee_id','rating_x','rating']]
    res['improvement_score'] = res['rating_x'] - res['rating']

    summary = pd.merge(employees,res, on = 'employee_id')[['employee_id','name','improvement_score']]
    return summary.sort_values(['improvement_score','name'], ascending = [0,1])