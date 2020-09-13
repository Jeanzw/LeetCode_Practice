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

-- 特别好的解法
SELECT Country.name AS country
FROM Person JOIN Calls ON Calls.caller_id = Person.id OR Calls.callee_id = Person.id
JOIN Country ON Country.country_code = LEFT(Person.phone_number, 3)
GROUP BY Country.name
HAVING AVG(duration) > (SELECT AVG(duration) FROM Calls)

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