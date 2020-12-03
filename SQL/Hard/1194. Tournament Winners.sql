-- 做对这道题的前提在于把要求给读明白：
-- The winner in each group is the player who scored the maximum total points within the group. 
-- In the case of a tie, the lowest player_id wins.
-- 也就是说我们其实根本不管match id的事情，并不是每一轮选出一个赢家，而是所有人拿着自己的分回到自己的队伍去然后看谁的分搞


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


-- 下面的做法比较简便
with player_score as
(select 
    first_player as id, 
    first_score as score
    from Matches
union all
select 
    second_player as id, 
    second_score as score
    from Matches)
-- 我上面用一个union all来将所有的player对应得到的分数求出来

select group_id,id as player_id from
(select id, group_id,
rank() over (partition by group_id order by sum(score) desc,player_id) as rnk 
from player_score
left join Players on Players.player_id = player_score.id
group by 1,2)tmp
where rnk = 1
-- 下面就是来看他们分数总和以及在各自group的排名