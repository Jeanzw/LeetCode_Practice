select class from courses 
group by 1
having count(distinct student) >= 5


-- 这道题我原本的解法是：
select class from courses 
group by 1
having count(*) >= 5
-- 这里出现的问题是：
-- {"headers": {"courses": ["student", "class"]}, 
--     "rows": {"courses": [["A", "Math"], 
--                         ["B", "English"], 
--                         ["C", "Math"], 
--                         ["D", "Biology"], 
--                         ["E", "Math"], 
--                         ["F", "Math"], 
--                         ["A", "Math"]]}}
-- 这里我们发现["A", "Math"]是重复值，那么如果直接count(*)就会报错  
-- -> 我们不需要担心这个问题，因为题目中说了(student, class) is the primary key，那么我们计算的时候直接count(student)即可


-- Python
import pandas as pd

def find_classes(courses: pd.DataFrame) -> pd.DataFrame:
    courses = courses.groupby(['class'],as_index = False).student.nunique()
    return courses[courses['student'] >= 5][['class']]