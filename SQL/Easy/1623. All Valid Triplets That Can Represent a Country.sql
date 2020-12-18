select 
    a.student_name as member_A ,
    b.student_name as member_B ,
    c.student_name as member_C
from SchoolA a,SchoolB b,SchoolC c
where a.student_name != b.student_name 
and a.student_id != b.student_id
and a.student_name != c.student_name 
and a.student_id != c.student_id
and b.student_name != c.student_name 
and b.student_id != c.student_id


-- 其实这道题由于三张表如果join起来是没有办法通过什么链接的，所以我们直接用上面的方式来将三张表集合起来
-- 但是我在工作中会发现，比如说在databrick里面，是不支持这样的做法的
-- 那么在这种情况下，我们会引入cross join
SELECT sa.student_name AS member_a
    , sb.student_name AS member_b
    , sc.student_name AS member_c
FROM schoola sa CROSS JOIN schoolb sb 
    CROSS JOIN schoolc sc
        WHERE sa.student_name != sb.student_name 
            AND sa.student_name != sc.student_name
            AND sb.student_name != sc.student_name
            AND sa.student_id != sc.student_id
            AND sb.student_id != sc.student_id
            AND sa.student_id != sb.student_id