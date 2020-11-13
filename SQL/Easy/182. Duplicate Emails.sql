select Email from
(select Email,count(*) as n from Person group by 1)m
where n > 1

-- 其实可以直接：
select Email from Person
group by 1
having count(*) > 1