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