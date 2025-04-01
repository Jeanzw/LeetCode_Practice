/*解说过程
如果两表联合应该是这样的
Id	Employee-id	amount	Pay_date	Department_id
1	1	        9000	2017-03-31	1
2	2	        6000	2017-03-31	2
3	3	        10000	2017-03-31	2
4	1	        7000	2017-02-28	1
5	2	        6000	2017-02-28	2
6	3	        8000	2017-02-28	2

然后我们从中抽取想要的列
select department_id, avg(amount) as department_avg, date_format(pay_date,'%Y-%m') as pay_month
from Salary left join employee on employee.employee_id = salary.employee_id
group by department_id,pay_month

Department_id	department_avg 	pay_month
1	            7000.0000	2017-02
1	            9000.0000	2017-03
2	            7000.0000	2017-02
2	            8000.0000	2017-03

select avg(amount) as month_avg, date_format(pay_date,'%Y-%m') as pay_month
from salary
group by pay_month

month_avg	pay_month
7000.0000	2017-02
8333.3333	2017-03


department_id	department_avg	pay_month	month_avg	pay_month
1	            7000.0000	    2017-02	    7000.0000	2017-02
2	            7000.0000	    2017-02	    7000.0000	2017-02
1	            9000.0000	    2017-03	    8333.3333	2017-03
2	            8000.0000	    2017-03	    8333.3333	2017-03

*/


select a.pay_month, department_id,
case 
when department_avg>month_avg then 'higher'
when department_avg<month_avg then 'lower'
else 'same' end as comparison
from 
(select department_id, avg(amount) as department_avg, date_format(pay_date,'%Y-%m') as pay_month
from Salary join employee on employee.employee_id = salary.employee_id
group by department_id,pay_month) as a
join
(select avg(amount) as month_avg, date_format(pay_date,'%Y-%m') as pay_month
from salary
group by pay_month) as b
on a.pay_month = b.pay_month
order by pay_month desc, department_id

----------------------

-- 其实这种题我觉得用subquery实在是可读性有点差，不如用cte来的清晰明了
-- 找到每个月公司的平均值
with company as
(select 
 date_format(pay_date,'%Y-%m') as pay_month,
 avg(amount) as com_avg
 from salary 
 group by 1)
--  找到每个月每个部门的平均值
, dep as
(select 
date_format(pay_date,'%Y-%m') as pay_month,
department_id,
avg(amount) as dep_avg
from salary s
left join employee e on s.employee_id = e.employee_id
group by 1,2)

-- 比较公司和部门
select 
d.pay_month,
department_id,
case 
    when dep_avg > com_avg then 'higher'
    when dep_avg < com_avg then 'lower'
    else 'same' end as comparison
from dep d
left join company c on d.pay_month = c.pay_month

----------------------

-- 也可以用window function
with cte as
(select
date_format(pay_date,'%Y-%m') as pay_month,
b.department_id,
amount
from Salary a
left join Employee b on a.employee_id = b.employee_id)
, cal as
(select 
pay_month,
department_id,
avg(amount) over (partition by pay_month, department_id) as dep_amount,
avg(amount) over (partition by pay_month) as com_amount
from cte)

select
pay_month,
department_id,
case when dep_amount > com_amount then 'higher' 
     when dep_amount = com_amount then 'same' 
     else 'lower' end as comparison
from cal
group by 1,2,3

----------------------

-- Python
import pandas as pd
import numpy as np

def average_salary(salary: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    salary['pay_month'] = salary['pay_date'].dt.strftime('%Y-%m')
    com = salary.groupby(['pay_month'],as_index = False).amount.mean()
    merge = pd.merge(salary,employee,on = 'employee_id')
    dep = merge.groupby(['pay_month','department_id'],as_index = False).amount.mean()

    compare = pd.merge(dep,com, on = 'pay_month',how = 'left')
    compare['comparison'] = np.where(compare['amount_x'] > compare['amount_y'], 'higher',
                            np.where(compare['amount_x'] < compare['amount_y'], 'lower','same')
                            )
    return compare[['pay_month','department_id','comparison']]

----------------------

-- 也可以这么做
import pandas as pd
import numpy as np

def average_salary(salary: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(salary,employee,on = 'employee_id')
    merge['pay_month'] = merge['pay_date'].dt.strftime('%Y-%m')
    merge['dep_avg'] = merge.groupby(['pay_month','department_id']).amount.transform('mean')
    merge['com_avg'] = merge.groupby(['pay_month']).amount.transform('mean')
    merge['comparison'] = np.where(merge['dep_avg'] > merge['com_avg'], 'higher',
                          np.where(merge['dep_avg'] == merge['com_avg'], 'same','lower'))
    return merge[['pay_month','department_id','comparison']].drop_duplicates()