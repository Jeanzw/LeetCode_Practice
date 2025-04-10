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

-------------------------------------

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

-------------------------------------

-- 我不懂为什么我之前说三张表没有办法通过什么链接……直接通过id以及name连接起来即可呀
-- join的存在不仅仅只可以找相同的数，我们还可以让不同的数连接起来
select
    a.student_name as member_A,
    b.student_name as member_B,
    c.student_name as member_C
    from SchoolA a
    join SchoolB b on a.student_id != b.student_id and a.student_name != b.student_name
    join SchoolC c on a.student_id != c.student_id and a.student_name != c.student_name and b.student_id != c.student_id and b.student_name != c.student_name 

-------------------------------------

-- 其实也可以全部直接先join，然后再最后在进行配对
select
a.student_name as member_A,
b.student_name as member_B,
c.student_name as member_C
from SchoolA a
inner join SchoolB b 
inner join SchoolC c 
on a.student_id != b.student_id and b.student_id != c.student_id and a.student_id != c.student_id
and a.student_name != b.student_name and b.student_name != c.student_name and a.student_name != c.student_name

-------------------------------------

-- Python
import pandas as pd

def find_valid_triplets(school_a: pd.DataFrame, school_b: pd.DataFrame, school_c: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(school_a,school_b,how = 'cross').merge(school_c, how = 'cross')
    merge = merge[(merge['student_id_x'] != merge['student_id_y']) & (merge['student_id_x'] != merge['student_id']) & (merge['student_id_y'] != merge['student_id']) & (merge['student_name_x'] != merge['student_name_y']) & (merge['student_name_x'] != merge['student_name']) & (merge['student_name_y'] != merge['student_name'])]
    return merge[['student_name_x','student_name_y','student_name']].rename(columns = {'student_name_x':'member_A','student_name_y':'member_B','student_name':'member_C'})