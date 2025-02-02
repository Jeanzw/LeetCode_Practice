select a.sub_id as post_id,count(distinct b.sub_id) as number_of_comments from Submissions a
left join Submissions b
on a.sub_id = b.parent_id
where a.parent_id is null
group by 1

----------------------------

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

----------------------------

-- 又一次做的，我把null的处理放到了最后
with post as
(select distinct sub_id from Submissions where parent_id is null)
,comment as
(select parent_id, count(distinct sub_id) as number_of_comments from Submissions
group by 1)

select p.sub_id as post_id,ifnull(number_of_comments,0) as number_of_comments  from post p
left join comment c on p.sub_id = c.parent_id
order by 1

----------------------------

-- Python
import pandas as pd

def count_comments(submissions: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(submissions,submissions,left_on = 'sub_id', right_on = 'parent_id', how = 'left')
    merge = merge[merge['parent_id_x'].isna()]
    merge = merge.groupby(['sub_id_x'], as_index = False).sub_id_y.nunique()
    return merge.rename(columns = {'sub_id_x':'post_id','sub_id_y':'number_of_comments'}).sort_values('post_id')