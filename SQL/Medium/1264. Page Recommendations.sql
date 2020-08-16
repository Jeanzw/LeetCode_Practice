select distinct page_id as recommended_page from
(
select user1_id as user_id,user2_id as friend from Friendship where user1_id = 1
union all
select user2_id as user_id,user1_id as friend from Friendship where user2_id = 1)tmp
left join Likes l on tmp.friend = l.user_id
where page_id not in
(select page_id from Likes where user_id = 1) and page_id is not null
