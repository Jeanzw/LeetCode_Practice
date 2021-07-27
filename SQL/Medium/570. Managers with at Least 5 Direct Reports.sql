select Name from Employee where Id in
(select ManagerId from Employee
group by 1 having count(*) >= 5)


-- 也可以直接用join来做
select 
    a.Name
    from Employee a
    join Employee b on a.Id = b.ManagerId
    group by 1
    having count(distinct b.Id) >= 5