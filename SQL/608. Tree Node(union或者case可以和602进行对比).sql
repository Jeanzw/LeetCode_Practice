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
1		NULL    1	    3
2	    1	    2	    4
2		1       2	    5
3	    1	    Null	
4	    2	    Null	
5	    2	    Null
*/	
