select name as results from
(select b.name,count(*) as num from Movie_Rating a
join Users b on a.user_id = b.user_id
group by 1
order by 2 desc,1 
limit 1) users

union all

select title as results from
(select b.title, avg(rating) as grade from Movie_Rating a
join Movies b on a.movie_id = b.movie_id and created_at between '2020-02-01' and '2020-02-29'
group by 1
order by 2 desc, 1
limit 1) movies


-- 如果用cte那么就是：
-- 我本来是用上面的方法，但是一直报错，后来检查了一下，每次union all前后我没有对这个view取一个 temp name
with user_rating as
(select m.user_id, name,count(distinct movie_id) as num from Movie_Rating m
 left join Users u on m.user_id = u.user_id
group by 1,2
order by 3 desc,2
limit 1)
,movie_rating as
(select mr.movie_id, title,avg(rating) as rate from Movie_Rating mr
left join Movies m on mr.movie_id = m.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by 1,2
order by 3 desc,2
limit 1)

select name as results from user_rating
union all
select title as results from movie_rating