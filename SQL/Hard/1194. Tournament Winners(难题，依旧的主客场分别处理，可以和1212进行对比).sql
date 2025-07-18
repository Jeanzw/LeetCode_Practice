-- 这一道题是不能做到直接按照下面写的，因为当我们第一个matches连接后可以保证每场比赛是出现一场，但是当我们第二个matches连起来后很可能第一个matches的同一场比赛的数据就变成多行了
-- with cte as
-- (select
-- a.group_id,
-- a.player_id,
-- sum(ifnull(b.first_score,0) + ifnull(c.second_score,0)) as score,
-- row_number() over (partition by a.group_id order by sum(ifnull(b.first_score,0) + ifnull(c.second_score,0)) desc, player_id) as rnk
-- from Players a
-- left join Matches b on a.player_id = b.first_player
-- left join Matches c on a.player_id = c.second_player
-- group by 1,2)

-- select
-- group_id, player_id
-- from cte
-- where rnk = 1

但是我们可以改变一下query，使其可以实现
with cte as
(select
a.group_id,
a.player_id,
sum(case when a.player_id = b.first_player then first_score else second_score end) as score,
-- 然后用case when来判断
row_number() over (partition by a.group_id order by sum(case when a.player_id = b.first_player then first_score else second_score end) desc, a.player_id) as rnk
from Players a
left join Matches b on a.player_id = b.first_player or a.player_id = b.second_player 
-- 我们用一个left join来判断是属于哪个阵营
-- 
group by 1,2
)

select
group_id, player_id from cte
where rnk = 1


---------------------------------------

/*
第一种解法是用MS SQL SEVER来解题
首先我们先把主客场的player_id的分数分别统计出来
而后和Players表的player_id进行联合，，挑出rank = 1的，由于题目中说了，如果rank一样的话，那么就抽出最小的player_id,所以我们在最开始抽取的时候，选择抽取min(player_id)
*/
select group_id, min(player_id) as player_id
from

(select a.player_id as player_id, group_id, sum(score) as score, rank() over (partition by group_id order by sum(score) desc) as rank
from Players a 

inner join 

(select first_player as player_id, first_score as score from Matches
union all
 select second_player as player_id, second_score as score from Matches) b

on a.player_id = b.player_id
group by a.player_id,group_id) c

where rank = 1
group by group_id

---------------------------------------

/*
而如果是用mysql来做就比较复杂了
*/
SELECT p1.group_id, MIN(sc.player) as player_id
FROM
(SELECT sco.player ,SUM(sco.score) AS score FROM
(
(SELECT first_player AS player ,SUM(first_score) AS score FROM Matches GROUP BY first_player )
UNION ALL
(SELECT second_player AS player ,SUM(second_score) AS score FROM Matches GROUP BY second_player )
) sco
GROUP BY sco.player ) sc

LEFT JOIN
Players p1
ON sc.player = p1.player_id
WHERE ( sc.score,p1.group_id) IN

---------------------------------------

-- #其实我下面的这一部分都是为了提供一个条件，就是我抽出最高的score,然后让上面抽出的内容满足下面的条件就好

(SELECT MAX(sc.score) as score ,p1.group_id  #我们之所以不抽出player_id因为可能会有同分数的情况，那么我们在之后再讨论
FROM
(SELECT sco.player ,SUM(sco.score) AS score FROM
 #下面的这一部分union all相当于是说，我们把Match里面的first_player和second_player合并成一列player
(
(SELECT first_player AS player ,SUM(first_score) AS score FROM Matches GROUP BY first_player )
UNION ALL
(SELECT second_player AS player ,SUM(second_score) AS score FROM Matches GROUP BY second_player )
) sco
GROUP BY sco.player ) sc

-- #既然我们已经把Matches表格里面的player_id和对应战绩弄出来，那么我们其实就可以和players表格合并了
LEFT JOIN
Players p1
ON sc.player = p1.player_id   #在下面有GROUP BY p1.group_id 之前都是正常的合并，但是因为我要从中选出最高的分数和对应的group_id所以我们需要在下面加一个group
GROUP BY p1.group_id  )
GROUP BY p1.group_id

---------------------------------------

/*另一种mysql的做法：利用group by是抽出最上面一层的内容*/
select group_id, player_id from (
	select p.group_id, ps.player_id, sum(ps.score) as score from Players p,
	    (select first_player as player_id, first_score as score from Matches
	    union all
	    select second_player, second_score from Matches) ps
	where p.player_id = ps.player_id
	group by ps.player_id order by group_id, score desc, player_id) top_scores
group by group_id

---------------------------------------

-- 或者直接用rank来看排序的情况
with raw_data as
(select first_player as id,first_score as score from Matches
union all
select second_player as id,second_score as score from Matches)
, player_team as
(select id,group_id,rank() over (partition by group_id order by score desc, id) as rnk from
(select 
id,
group_id,
sum(score) as score 
from  raw_data r
left join Players p on r.id = p.player_id
group by 1,2)tmp)

select group_id,id as player_id from player_team
where rnk = 1

---------------------------------------

-- Python
import pandas as pd

def tournament_winners(players: pd.DataFrame, matches: pd.DataFrame) -> pd.DataFrame:
    matches1 = matches[['first_player','first_score']].rename(columns = {'first_player':'player_id','first_score':'score'})
    matches2 = matches[['second_player','second_score']].rename(columns = {'second_player':'player_id','second_score':'score'})
    concat = pd.concat([matches1,matches2])

    merge = pd.merge(players,concat,on = 'player_id').groupby(['group_id','player_id'],as_index = False).score.sum()
    merge = merge.sort_values(['group_id','score','player_id'], ascending = [1,0,1])
    merge = merge.groupby(['group_id']).head(1)
    return merge[['group_id','player_id']]


-- 我们不能用下面的code：
-- merge = pd.merge(players,matches, left_on = 'player_id', right_on = 'first_player', how = 'left').merge(matches, left_on = 'player_id', right_on = 'second_player', how = 'left').fillna(0)
-- 问题在于，先按player_id=first_player做了一次merge，然后再按player_id=second_player又做了一次merge，会导致**数据被笛卡儿积(cross join)**并重复累加。
-- 举个简单例子，如果某位球员作为first_player参加了 2 场比赛，同时又作为second_player参加了 3 场比赛，那么两次 merge 之后，这位球员对应的行数会变成 2×3=6 行，分行累加就把分数给“乘”起来了。