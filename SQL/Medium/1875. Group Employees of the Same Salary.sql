-- 我的方法
with satisfied_salary as
(select 
    salary,
    count(distinct employee_id) as cnt
 from Employees
 group by 1
 having cnt >= 2)

select
    employee_id,
    name,
    salary,
    dense_rank() over (order by salary) as team_id
    from Employees
    where salary in (select salary from satisfied_salary)
    order by team_id,employee_id

-- 上面完全可以直接写：
select 
employee_id,
name,
salary,
dense_rank() over (order by salary) as team_id
from Employees 
where salary in (select salary from Employees group by 1 having count(*) > 1)
order by 4,1




-- 也可以直接用count() over ()来做   
select employee_id, name, salary, dense_rank() over(order by salary) team_id
from
(select employee_id, name, salary, count(employee_id) over(partition by salary) emp_nb
from employees) t
where emp_nb >=2