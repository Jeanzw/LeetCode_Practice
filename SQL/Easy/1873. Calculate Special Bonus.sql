-- 两个知识点：
-- 1.求余数，可以用mod也可以用%
-- 2.求M开头的名字，可以用left，也可以用like


-- 我做的
select 
    employee_id,
    case when mod(employee_id,2) = 1 and left(name,1) != 'M' then salary
    else 0 end as bonus
    from Employees
    order by 1


-- 别人做的1:
select employee_id, if(employee_id%2=1 and name not like'M%', salary,0) as bonus
from Employees;

-- 别人做的2:
SELECT employee_id,
       CASE
         WHEN employee_id % 2 = 1
              AND name NOT LIKE 'M%' THEN salary
         ELSE 0
       end AS bonus
FROM   employees
ORDER  BY employee_id 