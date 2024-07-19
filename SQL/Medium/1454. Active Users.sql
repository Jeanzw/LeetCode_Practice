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

-- 基于上一种方法的基础上写出下者：
-- 可以跑的并且不会timeout
with raw as
(select distinct l1.id from Logins l1
join Logins l2 on l1.id = l2.id and datediff(l2.login_date,l1.login_date) = 1
join Logins l3 on l2.id = l3.id and datediff(l3.login_date,l2.login_date) = 1
join Logins l4 on l3.id = l4.id and datediff(l4.login_date,l3.login_date) = 1
join Logins l5 on l4.id = l5.id and datediff(l5.login_date,l4.login_date) = 1)

select * from Accounts
where id in (select * from raw)
order by id





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


-- 下面这种更容易看
with dedup as
(select
distinct a.id,
a.name,
login_date,
dense_rank() over (partition by a.id order by login_date) as rnk
from Accounts a
inner join Logins b on a.id = b.id)
-- 先把duplicate全部剔除掉

, bridge as
(select
id, name, dateadd(day, - rnk,login_date) as bridge
from dedup)
-- 用dateadd建筑桥梁

select distinct id, name from bridge 
group by id,name,bridge
having count(*) >=5
order by id



-- Python
import pandas as pd

def active_users(accounts: pd.DataFrame, logins: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(logins,accounts,on='id', how = 'left').drop_duplicates().sort_values(['id','login_date'])
    merge['occ'] = 1
    merge = merge.groupby(['id','name'],as_index = False).rolling('5D',min_periods = 5, on = 'login_date').sum()
    return merge.query("occ.notna()")[['id','name']].drop_duplicates()