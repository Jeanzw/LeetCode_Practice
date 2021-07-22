with manager as
(select 
    reports_to,
    count(distinct employee_id) as reports_count,
    round(avg(age),0) as average_age 
    from Employees
    where reports_to is not null
    group by 1)
    
select 
    m.reports_to as employee_id,
    name,
    reports_count,
    average_age 
    from manager m
    join Employees e on m.reports_to = e.employee_id
    order by 1


-- 我用另一种方法做了一遍，就是直接求和，并不需要使用cte
-- 下面这种方法是必须要先于上面的方法写出来的，因为根据几次面试的经验，这种可以直接join而不是复杂的题目，写出下面的才是考察的关键
select 
    a.employee_id,
    a.name,
    count(distinct b.employee_id) as reports_count,
    round(avg(b.age),0) as average_age
    from Employees a
    join Employees b on a.employee_id = b.reports_to
    group by 1,2
    order by 1