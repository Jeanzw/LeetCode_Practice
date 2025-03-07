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

------------------------------

-- Python
import pandas as pd

def get_election_results(votes: pd.DataFrame) -> pd.DataFrame:
    votes['cnt'] = votes.groupby(['voter']).candidate.transform('nunique')
    votes['vote'] = 1/votes['cnt']
    votes = votes.groupby(['candidate'],as_index = False).vote.sum()
    votes['rnk'] = votes.vote.rank(method = 'dense', ascending = False)
    return votes[votes['rnk'] == 1][['candidate']].sort_values('candidate')