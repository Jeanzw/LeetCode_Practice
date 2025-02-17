select employee_id,department_id from
(select employee_id,department_id from Employee
where primary_flag = 'Y'

union all

select employee_id,department_id from Employee
where employee_id in (select employee_id from Employee group by 1 having count(*) = 1))tmp
group by 1,2

--------------------

-- 和上面原理相似
select employee_id,department_id from Employee
where primary_flag = 'Y'
union all
select employee_id,department_id from Employee
where employee_id not in (select employee_id from Employee
where primary_flag = 'Y')

--------------------

-- 另外我们可以直接用union来做，union和union all的区别在于前者会自动合并重复值
select employee_id,department_id from Employee
where primary_flag = 'Y'

union 

select employee_id,department_id from Employee
where employee_id in (select employee_id from Employee group by 1 having count(*) = 1)

--------------------

-- 另一种做法使用window function来做
-- 其实这一种方法我觉得是熟练之后应该立刻要想到的方法
SELECT EMPLOYEE_ID,DEPARTMENT_ID
FROM
(
SELECT *,COUNT(EMPLOYEE_ID) OVER(PARTITION BY EMPLOYEE_ID) C
FROM EMPLOYEE
)T
WHERE C=1 OR PRIMARY_FLAG='Y'

--------------------

-- Python
import pandas as pd

def find_primary_department(employee: pd.DataFrame) -> pd.DataFrame:
    employee['cnt'] = employee.groupby(['employee_id']).department_id.transform('count')
    employee = employee[(employee['cnt'] == 1) | (employee['primary_flag'] == 'Y') ]
    return employee[['employee_id','department_id']]