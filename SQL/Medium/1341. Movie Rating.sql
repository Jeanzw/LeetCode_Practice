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



-- 上面的可以缩减成：
(select 
name as results
from Users u join Movie_Rating m on u.user_id = m.user_id
group by 1
order by count(distinct movie_id) desc,1
limit 1)

union all

(select title as results
from Movies m join Movie_Rating m1 on m.movie_id = m1.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by 1
order by avg(rating) desc,1
limit 1)



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



-- Python
import pandas as pd

def movie_rating(movies: pd.DataFrame, users: pd.DataFrame, movie_rating: pd.DataFrame) -> pd.DataFrame:
    users = pd.merge(users,movie_rating, on ='user_id').groupby(['user_id','name'],as_index = False).agg(
        results = ('movie_id','count')
    ).sort_values(['results','name'], ascending = [False, True]).head(1)
    users = users[['name']].rename(columns = {'name':'results'})

    movies = pd.merge(movies,movie_rating, on ='movie_id').query("created_at >= '2020-02-01' and created_at <= '2020-02-29'").groupby(['movie_id','title'],as_index = False).agg(
        results = ('rating','mean')
    ).sort_values(['results','title'], ascending = [False, True]).head(1)

    movies = movies[['title']].rename(columns = {'title':'results'})

    res = pd.concat([users,movies])
    return res