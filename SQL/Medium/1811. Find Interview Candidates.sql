with result as
(select distinct medal from
(select gold_medal as medal from Contests
group by 1
having count(distinct contest_id) >= 3
union all
select distinct medal from
(select contest_id, medal,row_number() over (partition by medal order by contest_id) as rnk from
(select contest_id,gold_medal as medal from Contests
union all
select contest_id,silver_medal as medal from Contests
union all
select contest_id,bronze_medal as medal from Contests)t)tt
group by medal, contest_id - rnk
having count(*) >= 3) summary)


select name,mail from Users 
where user_id in (select medal from result)