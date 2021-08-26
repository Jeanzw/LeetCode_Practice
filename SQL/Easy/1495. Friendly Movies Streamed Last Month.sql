select title from Content
where Kids_content = 'Y' 
and content_type = 'Movies'
and content_id in 
(select content_id from TVProgram
where program_date between '2020-06-01' and '2020-06-30')


-- 或者直接用join也可以
select 
distinct title
from TVProgram t join Content c on t.content_id = c.content_id
where program_date between '2020-06-01' and '2020-06-30'
and content_type = 'Movies'
and Kids_content = 'Y'