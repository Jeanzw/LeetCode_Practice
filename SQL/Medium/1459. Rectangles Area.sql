-- 我们这道题不要想的太复杂了
-- 我们注意到题目中又一个这样的限定：p1 and p2 are the id of two opposite corners of a rectangle and p1 < p2.
-- 那么其实就说明，这两点就是对角的两个点，那么我们只要保证这两点的横纵坐标都是不一样的
select 
    a.id as p1,
    b.id as p2,
    abs(a.x_value - b.x_value) * abs(a.y_value - b.y_value) as area
    from Points a
    join Points b
    on a.id < b.id  
--在这里我们保证了a的id是小于b的id的，这样其实就保证了一个顺序性，因为题目中说了p1 and p2 are the id of two opposite corners of a rectangle and p1 < p2.
    and a.x_value != b.x_value
    and a.y_value != b.y_value
    order by 3 desc, 1,2


-- 再一次做的：
select 
    p1.id as p1, 
    p2.id as p2, 
    abs(p1.x_value - p2.x_value) * abs(p1.y_value - p2.y_value) as area
from Points p1
left join Points p2 on p1.id < p2.id
group by 1,2,3
having area != 0 and area is not null
order by 3 desc,1,2