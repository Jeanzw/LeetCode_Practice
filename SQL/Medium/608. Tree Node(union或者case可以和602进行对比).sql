/*用union来解题*/
select Id,'Root' as Type from tree
where p_id is null

union

/*叶子相当于就是说我们在p_id里面是找不到对应的id的*/

select id,'Leaf' as Type from tree
where id not in (select distinct p_id from tree where p_id is not null) and p_id is not null

union

/*inner就相当于是说我们在p_id里面是找得到这个id的*/
select id,'Inner' as Type from tree 
where id in (select distinct p_id from tree where p_id is not null) and p_id is not null

order by id




/*用case来解题*/
-- 我们这里用第一个表的id和第二个表的p_id是因为，我们其实要考虑这个id是否是在p_id里面的


select distinct a.id,
(case when a.p_id is not null and b.id is not null then 'Inner'
      when a.p_id is not null and b.id is null then 'Leaf' 
      else 'Root' end) as Type
from tree as a left join tree as b
on a.id=b.p_id
order by a.id
/*凑出来的表格如下
a.id	a.p_id	b.p_id	b.id
1	    Null 	1	    2
1	    NULL    1	    3
2	    1	      2	    4
2	    1       2	    5
3	    1	    Null	
4	    2	    Null	
5	    2	    Null
*/	


-- 如果用left join也可以直接这样写：
select 
    t1.id,
    case 
        when t1.p_id is null then 'Root'
        when t2.id is not null then 'Inner'
        else 'Leaf' end as Type
    from tree t1
    left join tree t2 on t1.id = t2.p_id
    group by 1,2



-- 对于第三次做的时候，我还是选择了用case when而不是union all的方式
-- 我们的目的其实就是，如果p_id是null，那么肯定就是Root
-- 如果id这个数字在p_id里面，同时其p_id不是null，那么就是Leaf
-- 如果id这个数字不在p_id里面，同时其p_id不是null，那么就是Inner
-- 在这个基础上，我们首先开一个temp view，然后把p_id给抽出来
-- 在case when的时候，我们就针对上面讨论的Root，Leaf和Inner分别讨论
with p_type as
(select p_id from tree where p_id is not null)


select id,
case when p_id is null then 'Root'
    when id not in (select p_id from p_type) and p_id is not null then 'Leaf'
    else 'Inner' end as Type 
    from tree


-- 其实下面这种方法应该是最简单的了：
select 
    id,
    case when p_id is null then 'Root'
    when id in (select p_id from tree) then 'Inner'
    else 'Leaf' end as Type
from tree