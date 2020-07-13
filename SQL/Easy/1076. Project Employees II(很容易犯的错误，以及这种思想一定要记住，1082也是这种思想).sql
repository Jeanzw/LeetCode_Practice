/*这道题我最开始好像一直想要用max(count(*))这样的方式来计算count最大者，这样是不对的，做不出来的*/
select project_id from Project 
group by project_id
having count(*) =
(select count(*) from Project group by project_id order by count(*) desc limit 1)

/*无论是求最大还是最小，如果不是直接涉及max可以做到的情况之下，都要用where来进行选择一番
但是如果是MS SQL Server那么就直接ranking来解决了*/

select project_id from
(select project_id,dense_rank() over (order by count(*) desc) as ranking from Project
group by project_id)tmp
where ranking = 1
