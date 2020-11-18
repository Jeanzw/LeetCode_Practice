select Name from Candidate 
where id in
(
select CandidateId from
(select CandidateId,count(*) as n 
 from Vote 
 group by 1 
 order by n desc limit 1)tmp)