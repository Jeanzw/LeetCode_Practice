select title from Content
where Kids_content = 'Y' 
and content_type = 'Movies'
and content_id in 
(select content_id from TVProgram
where program_date between '2020-06-01' and '2020-06-30')