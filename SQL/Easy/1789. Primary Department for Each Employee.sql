select employee_id,department_id from
(select employee_id,department_id from Employee
where primary_flag = 'Y'

union all

select employee_id,department_id from Employee
where employee_id in (select employee_id from Employee group by 1 having count(*) = 1))tmp
group by 1,2


-- 另外我们可以直接用union来做，union和union all的区别在于前者会自动合并重复值
select employee_id,department_id from Employee
where primary_flag = 'Y'

union 

select employee_id,department_id from Employee
where employee_id in (select employee_id from Employee group by 1 having count(*) = 1)


-- 另一种做法使用window function来做
SELECT EMPLOYEE_ID,DEPARTMENT_ID
FROM
(
SELECT *,COUNT(EMPLOYEE_ID) OVER(PARTITION BY EMPLOYEE_ID) C
FROM EMPLOYEE
)T
WHERE C=1 OR PRIMARY_FLAG='Y'