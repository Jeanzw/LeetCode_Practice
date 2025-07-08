select sum(TIV_2016) as TIV_2016 from insurance
where TIV_2015 IN (select TIV_2015 from insurance group by TIV_2015 having count(*) >1)
and
concat(LAT,LON) IN (select concat(LAT,LON) from insurance group by LAT,LON having count(*)=1)

----------------------------------

/*or*/

select round(sum(TIV_2016),2) as TIV_2016 from Insurance
where TIV_2015 in (select TIV_2015 from insurance group by TIV_2015 having count(TIV_2015) > 1)
and concat(LAT,LON) not in   /*我们这里就是要将两个维度放在一起考虑的，所以这里一定要用concat将他们两个给组合到一起*/
(select concat(LAT,LON) from insurance group by LAT,LON having count(concat(LAT,LON)) > 1)

----------------------------------

-- 其实我们也可以不用concat，而直接用
with unique_tiv_2015 as
(select TIV_2015 from insurance
group by 1
having count(*) = 1)
-- 上面我们找出TIV_2015是独一无二的，然后保证最后结果不在这之内
, unique_location as
(select LAT,LON from insurance
group by 1,2
having count(*) = 1)
-- 上面这我们找出LAT，LON是独一无二的，然后保证最后结果就在这之内

select round(sum(TIV_2016),2) as TIV_2016 from insurance 
where TIV_2015 not in (select * from unique_tiv_2015)
and (LAT,LON) in (select * from unique_location)

----------------------------------

-- 最好不要用In来做
with same_2015 as
(select distinct a.pid from Insurance a inner join Insurance b on a.tiv_2015 = b.tiv_2015 and a.pid != b.pid)
, same_location as
(select distinct a.pid from Insurance a inner join Insurance b on a.lat = b.lat and a.pid != b.pid and a.lon = b.lon)

select 
round(sum(a.tiv_2016),2) as tiv_2016
from Insurance a
left join same_2015 b on a.pid = b.pid
left join same_location c on a.pid = c.pid
where b.pid is not null and c.pid is null

----------------------------------

-- 其实这道题也可以用join来做
-- 我们这里一定要先找到distinct tiv_2016和对应的pid，不然我们在做left join的时候，如果有很多行满足条件就会让tiv_2016变成多行
-- 然后我们如果不找到distinct tiv_2016和对应的pid，就会在计算的时候反复计算
select sum(TIV_2016) as TIV_2016 from
(select
a.PID,
a.TIV_2016
from insurance a
join insurance b on a.TIV_2015 = b.TIV_2015 and a.PID != b.PID
left join insurance c on a.LAT = c.LAT and a.LON = c.LON and a.PID != c.PID 
-- 这里相当于我先满足同location的条件来进行join，然后用where把这一部分的人群给剔除掉
where c.PID is null
group by 1,2)tmp

----------------------------------

-- 我再一次做的时候就会发现，这道题其实要满足两个条件
-- 1. tiv_2015 要有多行一样
-- 2. lat，lon 要唯一
-- 既然是这样我们完全就可以用window function来计数，看tiv_2015对应的数字有几行一样，lat，lon 对应的坐标有几行一样
-- 然后最后用where去满足1和2即可

with cte as 
(select
*, 
count(pid) over (partition by tiv_2015) as cnt_sum,
count(pid) over (partition by lat,lon) as location_sum
from Insurance)

select round(sum(tiv_2016),2) as tiv_2016
from cte
where cnt_sum > 1 and location_sum = 1

----------------------------------

-- Python
import pandas as pd

def find_investments(insurance: pd.DataFrame) -> pd.DataFrame:
    merge1 = pd.merge(insurance,insurance,on = 'tiv_2015').query("pid_x != pid_y")
    merge2 = pd.merge(merge1,insurance,left_on = ['lat_x','lon_x'], right_on = ['lat','lon'],how = 'left')

    summary = merge2.groupby(['pid_x','tiv_2016_x'],as_index = False).pid.nunique() --判断链接了多少个相同location的id
    summary = summary.query("pid == 1").tiv_2016_x.sum()
    -- 如果只有一个连接的id，就是自己，就说明可行
    return pd.DataFrame({'tiv_2016':[summary]})

----------------------

-- 也可以这么做
import pandas as pd

def find_investments(insurance: pd.DataFrame) -> pd.DataFrame:
    insurance['tiv_2015_count'] = insurance.groupby(['tiv_2015']).pid.transform('nunique')
    insurance['location_count'] = insurance.groupby(['lat','lon']).pid.transform('nunique')
    insurance = insurance[(insurance['tiv_2015_count'] > 1) & (insurance['location_count'] == 1)]
    return pd.DataFrame({'tiv_2016': [insurance.tiv_2016.sum()]})