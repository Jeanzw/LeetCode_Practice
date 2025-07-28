select country from
(select p.*, c.name as country, duration from Person p
left join Country c on left(p.phone_number,3) = country_code
left join
(
select caller_id as id, duration from Calls
union all 
select callee_id as id, duration from Calls
    )d on p.id = d.id) tmp
    group by 1 --在这一步我们下面我们进行筛选
    -- 其实平均值我们不需要将Calls这个表进行union然后求出平均值，而是直接对这个表求平均值就好了，这个是需要注意的地方
    having avg(duration) >
    (select avg(duration) from Calls)

-------------------------------------------

-- 特别好的解法，也就是说直接用avg就可以解决这个问题了
SELECT Country.name AS country
FROM Person JOIN Calls ON Calls.caller_id = Person.id OR Calls.callee_id = Person.id  --此处其实我觉得做一个cte没有问题，会更加清楚在干嘛
JOIN Country ON Country.country_code = LEFT(Person.phone_number, 3)
GROUP BY Country.name
HAVING AVG(duration) > (SELECT AVG(duration) FROM Calls)

-------------------------------------------

-- 还可以的解法：这些其实都是在对Calls这张表如何处理来做文章
SELECT
 co.name AS country
FROM
 person p
 JOIN
     country co
     ON SUBSTRING(phone_number,1,3) = country_code
 JOIN
     calls c
     ON p.id IN (c.caller_id, c.callee_id)
GROUP BY
 co.name
HAVING
 AVG(duration) > (SELECT AVG(duration) FROM calls)

-------------------------------------------

--  后来重新做的方法：
with country_duration as
(select caller_id as id, duration from Calls
union all
 select callee_id as id, duration from Calls
)
, country_person as
(select id,c.name as country from Person p left join Country c on left(phone_number,3) = country_code)


select country from country_duration cd
left join country_person cp on cd.id = cp.id
group by 1
having avg(duration) > (select avg(duration) from Calls)

-------------------------------------------

-- 另外的方法：
with rawdata as
(select caller_id as id, duration from Calls
union all
select callee_id as id, duration from Calls)
,globaldata as
(select avg(duration) as global_duration from rawdata)
-- 这里我们先把global avg给求出来

select 
c.name as country
from rawdata r
left join Person p on r.id = p.id
left join Country c on left(p.phone_number,3) = country_code
group by 1
having avg(duration) > (select global_duration from globaldata)
-- 在最后保证我们这里每个国家的avg duration是大于global duration

-------------------------------------------

-- 另外的方法，直接用window function做
with calls_duration as
(select caller_id as id, duration from Calls
union all
select callee_id as id, duration from Calls
)
, summary as
(select 
a.id, a.duration, c.name,
avg(duration) over (partition by c.name) as country_avg,
avg(duration) over () as global_avg
from 
calls_duration a
left join Person b on a.id = b.id
left join Country c on left(phone_number,3) = country_code
)

select distinct name as country from summary
where country_avg > global_avg

-------------------------------------------

-- Python
import pandas as pd

def find_safe_countries(person: pd.DataFrame, country: pd.DataFrame, calls: pd.DataFrame) -> pd.DataFrame:
    call1 = calls[['caller_id','duration']].rename(columns = {'caller_id':'id'})
    call2 = calls[['callee_id','duration']].rename(columns = {'callee_id':'id'})
    call = pd.concat([call1,call2])
    person['country_code'] = person['phone_number'].str[:3]
    merge = pd.merge(country,person,on = 'country_code').merge(call, on = 'id', how = 'left')

    merge['country_avg'] =  merge.groupby('name_y').duration.transform(mean)
    merge['global_avg'] =  merge.duration.mean()
    merge = merge[merge['country_avg'] > merge['global_avg']]
    return merge[['name_x']].drop_duplicates().rename(columns = {'name_x':'country'})