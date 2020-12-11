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





-- 我其实后来做，一眼看到这个题就想到了1225，但是我们如何应用到这道题呢
```
我最开始想的是用这种方式，这种方式就是和1225一模一样
with more_5_consecutive_date as
(select id, count(*) as cnt from
(select id,login_date,
rank() over (partition by id order by login_date) as rnk 
from Logins)tmp
group by id, dateadd(day,-rnk,login_date)
having count(*) >= 5)

select * from Accounts
where id in (select id from more_5_consecutive_date)
可是会报错，报错的原因我们可以看看下面这个例子
也就是说，其实在这一组数据中是可能存在重复值的
{"headers": 
["id", "login_date"], "values": 
[[136, "2020-06-26"], 
[136, "2020-06-26"], 
[136, "2020-06-27"], 
[136, "2020-06-28"], 
[136, "2020-06-28"], 
[136, "2020-06-28"], 
[136, "2020-07-01"], 
[136, "2020-07-02"], 
[136, "2020-07-05"], 
[136, "2020-07-05"]]}

所以如果我们就是要采用像是1225这样的做法，那么我们可以先删除重复值

```
with delte_duplicate_value as
(select id,login_date from Logins group by id,login_date)

,more_5_consecutive_date as
(select id, count(*) as cnt from
(select id,login_date,
rank() over (partition by id order by login_date) as rnk 
from delte_duplicate_value)tmp
group by id, dateadd(day,-rnk,login_date)
having count(*) >= 5)

select * from Accounts
where id in (select id from more_5_consecutive_date)
order by id
