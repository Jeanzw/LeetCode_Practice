select distinct id from
(select view_date, viewer_id as id, count(distinct article_id) as n from Views
group by 1,2 
having n > 1)tmp
order by id

-- 其实也可以直接算不需要两步
select distinct viewer_id as id from Views
group by view_date,viewer_id
having count(distinct article_id) > 1
order by 1