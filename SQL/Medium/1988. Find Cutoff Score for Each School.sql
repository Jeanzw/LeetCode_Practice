select 
    school_id,
    case when score is null then -1 else score end as score
from
(select 
    s.school_id,
    score,
    rank() over (partition by s.school_id order by student_count desc, score asc) as rnk
    from
    Schools s
    left join Exam e on s.capacity >= e.student_count)tmp
    where rnk = 1