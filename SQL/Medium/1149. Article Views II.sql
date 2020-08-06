select distinct id from
(select view_date, viewer_id as id, count(distinct article_id) as n from Views
group by 1,2 
having n > 1)tmp
order by id