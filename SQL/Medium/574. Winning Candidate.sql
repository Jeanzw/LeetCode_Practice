select Name from Candidate 
where id in
(
select CandidateId from
(select CandidateId,count(*) as n 
 from Vote 
 group by 1 
 order by n desc limit 1)tmp)

--------------------------

-- 下面举一个错误例子
-- 这样子其实会报错，因为：This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
select Name from Candidate 
where id in
(select CandidateIdas n 
 from Vote 
 group by 1 
 order by count(*) desc limit 1)

--------------------------

-- 但是如果我们用cte来做其实是可行的
 with most_vote as
(select CandidateId from Vote
group by 1
order by count(*) desc limit 1)

select Name from Candidate 
where id in (select * from most_vote)

--------------------------

-- 或者直接用join来做这道题
select 
Name 
from Candidate c
join Vote v on c.id = v.CandidateId
group by 1
order by count(*) desc
limit 1

--------------------------

-- 但我觉得上面解法也有问题，因为还是可能存在同名的情况
select
a.name
from Candidate a
inner join Vote b on a.id = b.candidateId
group by a.id, a.name
order by count(distinct b.id) desc
limit 1

--------------------------

-- Python
import pandas as pd

def winning_candidate(candidate: pd.DataFrame, vote: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(candidate,vote,left_on = 'id', right_on = 'candidateId')
    merge = merge.groupby(['id_x','name'],as_index = False).id_y.nunique()
    merge = merge.sort_values('id_y', ascending = False)
    return merge[['name']].head(1)