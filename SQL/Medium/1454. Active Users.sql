select distinct a.id, name from Logins a
join Logins b on a.id = b.id and datediff(a.login_date,b.login_date) between 1 and 4
join Accounts acc on a.id = acc.id
group by a.id,a.login_date
having count(distinct b.login_date) = 4


-- 下面这种做法是符合逻辑的，但是timeout了
select distinct a.id, name from Logins a
join Logins b on a.id = b.id and datediff(a.login_date,b.login_date) = 1
join Logins c on a.id = c.id and datediff(b.login_date,c.login_date) = 1
join Logins d on a.id = d.id and datediff(c.login_date,d.login_date) = 1
join Logins e on a.id = e.id and datediff(d.login_date,e.login_date) = 1
join Accounts acc on a.id = acc.id
order by 1