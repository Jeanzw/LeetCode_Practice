select Name from Candidate 
where id in
(
select CandidateId from
(select CandidateId,count(*) as n 
 from Vote 
 group by 1 
 order by n desc limit 1)tmp)

-- 下面举一个错误例子
-- 这样子其实会报错，因为：This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
select Name from Candidate 
where id in
(select CandidateIdas n 
 from Vote 
 group by 1 
 order by count(*) desc limit 1)


-- 但是如果我们用cte来做其实是可行的
 with most_vote as
(select CandidateId from Vote
group by 1
order by count(*) desc limit 1)

select Name from Candidate 
where id in (select * from most_vote)