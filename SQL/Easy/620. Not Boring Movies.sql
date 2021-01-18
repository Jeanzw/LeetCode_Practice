select * from cinema
where id % 2 = 1 and description != 'boring'
order by rating desc

-- 求余数可以用mod
select * from cinema
where mod(id,2) = 1
and description != 'boring'
order by rating desc