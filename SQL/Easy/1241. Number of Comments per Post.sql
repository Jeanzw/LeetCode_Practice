select a.sub_id as post_id,count(distinct b.sub_id) as number_of_comments from Submissions a
left join Submissions b
on a.sub_id = b.parent_id
where a.parent_id is null
group by 1


-- 第二次做的
with post as
(select sub_id as id from Submissions 
where parent_id is null group by 1)
, comments as
(select sub_id,parent_id from Submissions
where parent_id in (select * from post)
group by 1,2)

select 
    id as post_id,
    count(distinct sub_id) as number_of_comments from post p
    left join comments c on p.id = c.parent_id
    group by 1