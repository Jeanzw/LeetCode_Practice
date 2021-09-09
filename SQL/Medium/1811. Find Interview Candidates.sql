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


-- 上面的看起来……有点繁杂，简化如下
with gold as
(select gold_medal as player
from Contests
group by 1
having count(*) >= 3)
, three_medal as
(select distinct player from
(select contest_id, player, dense_rank() over (partition by player order by contest_id) as rnk 
from
(select contest_id, gold_medal as player from Contests
union all 
select contest_id, silver_medal as player from Contests
union all 
select contest_id, bronze_medal as player from Contests)tmp)tt

group by player, contest_id - rnk
having count(*) >= 3)


select name,mail from Users
where user_id in (select * from gold union all select * from three_medal)



-- 我看到另一种解法说是用lag（）
with cte as (
    select
        user_id,
        name,
        mail,
        contest_id,
        user_id = gold_medal as gold,
        user_id = silver_medal as silver,
        user_id = bronze_medal as bronze,
        lag(contest_id, 2) over (partition by user_id order by contest_id) as prevprev
    from
        Users
    left join
        Contests on user_id = gold_medal or user_id = silver_medal or user_id = bronze_medal
)
select
    name,
    mail
from
    cte
group by
    user_id
having
    sum(gold) >= 3
or
    sum(contest_id - prevprev = 2) >= 1