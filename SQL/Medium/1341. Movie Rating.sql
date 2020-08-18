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