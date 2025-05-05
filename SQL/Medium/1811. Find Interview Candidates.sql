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

---------------------------------

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

---------------------------------

-- 上面这种方法可以在算three medal用join来连接
with gold as
(select b.name,b.mail from Contests a inner join Users b on a.gold_medal = b.user_id
group by 1,2 having count(distinct contest_id) >= 3)
, consecutive_summary as
(select 
    b.name,
    b.mail,
    a.contest_id, 
    row_number() over (partition by b.user_id order by contest_id) as rnk,
    a.contest_id - row_number() over (partition by b.user_id order by contest_id) as bridge
from Contests a 
inner join Users b 
on a.gold_medal = b.user_id or a.silver_medal = b.user_id or a.bronze_medal = b.user_id
order by 1,4)
, consecutive as
(select name, mail from consecutive_summary group by 1,2,bridge having count(*) >= 3)

select distinct name,mail from gold
union
select distinct name, mail from consecutive

---------------------------------

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

---------------------------------

-- 或者直接用最简单的方法
with gold_medal as
(select 
gold_medal as user_id
from Contests
group by 1
having count(distinct contest_id) >= 3)
, frame as
(select contest_id, gold_medal as user_id from Contests
union
select contest_id, silver_medal as user_id from Contests
union
select contest_id, bronze_medal as user_id from Contests
)
, consecutive_medal as
(select
distinct a.user_id
from frame a
join frame b on a.user_id = b.user_id and a.contest_id + 1 = b.contest_id
join frame c on a.user_id = c.user_id and a.contest_id + 2 = c.contest_id)
, summary as
(select user_id from gold_medal
union
select user_id from consecutive_medal
)

select
a.name,
a.mail
from Users a
join summary b on a.user_id = b.user_id

---------------------------------

-- Python
import pandas as pd

def find_interview_candidates(contests: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    gold = contests.groupby(['gold_medal'],as_index = False).contest_id.nunique()
    gold = gold.query("contest_id >= 3")[['gold_medal']].rename(columns = {'gold_medal':'user_id'})
    gold_medal = contests[['contest_id','gold_medal']].rename(columns = {'gold_medal':'medal'})
    silver_medal = contests[['contest_id','silver_medal']].rename(columns = {'silver_medal':'medal'})
    bronze_medal = contests[['contest_id','bronze_medal']].rename(columns = {'bronze_medal':'medal'})
    medal = pd.concat([gold_medal,silver_medal,bronze_medal]).sort_values(['medal','contest_id'])
# 我最开始的时候做的是shift(-1)，因为我想要和sql一样求出一个bridge，但是在Python其实可以更简单
# 直接就是shift(-2)，因为我们要求出的是连续三个数，那么我们保证下下行和这一行相差2那么中间一行肯定和当前行就相差1
# 然后我们也不需要再Groupby了，直接就抽取diff为2的即可
    medal['shift'] = medal['contest_id'].shift(-2)
    medal['diff'] = medal['shift'] - medal['contest_id']
    medal = medal.query("diff == 2")[['medal']].rename(columns = {'medal':'user_id'})
    summary = pd.concat([gold,medal])
    sumamry = pd.merge(summary,users, on = 'user_id')
    return sumamry[['name','mail']].drop_duplicates()

---------------------------------

-- 如果不用shift，那么我们可以按照sql的思路，建一个bridge出来
import pandas as pd

def find_interview_candidates(contests: pd.DataFrame, users: pd.DataFrame) -> pd.DataFrame:
    # gold
    gold = contests.groupby(['gold_medal'],as_index = False).contest_id.nunique()
    gold = gold.query("contest_id >= 3").rename(columns = {'gold_medal':'id'})
    # three medal
    gold_medal = contests[['contest_id','gold_medal']].rename(columns = {'gold_medal':'id'})
    silver_medal = contests[['contest_id','silver_medal']].rename(columns = {'silver_medal':'id'})
    bronze_medal = contests[['contest_id','bronze_medal']].rename(columns = {'bronze_medal':'id'})
    medal = pd.concat([gold_medal,silver_medal,bronze_medal])
    medal['bridge'] = medal.groupby(['id']).contest_id.transform('rank',method = 'first')
    medal['bridge'] = medal['contest_id'] - medal['bridge']
    three_medal = medal.groupby(['id','bridge'],as_index = False).contest_id.nunique()
    three_medal = three_medal.query("contest_id >= 3")[['id']]

    # candidate
    candidate = pd.concat([gold,three_medal])[['id']].drop_duplicates()

    merge = pd.merge(candidate,users,left_on = 'id', right_on = 'user_id')
    return merge[['name','mail']].drop_duplicates()