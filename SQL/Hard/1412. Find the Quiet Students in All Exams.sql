with non_quiet as
(select distinct student_id from
(select 
    *,
    dense_rank() over (partition by exam_id order by score) as rnk_acs,
    dense_rank() over (partition by exam_id order by score desc) as rnk_desc
    from Exam) tmp
    where rnk_acs = 1 or rnk_desc = 1)
    
    select b.student_id,b.student_name from Exam a
    left join Student b on a.student_id = b.student_id
    where a.student_id not in (select * from non_quiet)
    group by b.student_id,b.student_name
    order by student_id