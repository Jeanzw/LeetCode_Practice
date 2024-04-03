with vote as
(select 
    voter, 
    count(distinct candidate) as vote_cnt 
    from Votes 
where candidate is not null 
group by 1 )
, rnk as
(select
a.candidate,
sum(1/vote_cnt) as voted,
dense_rank() over (order by sum(1/vote_cnt) desc) as rnk
from Votes a
left join vote b on a.voter = b.voter
group by 1)

select candidate from rnk where rnk = 1 order by 1