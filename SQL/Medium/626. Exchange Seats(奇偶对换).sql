select
case when mod(id,2) != 0 and id != cnts then id + 1
     when mod(id,2) != 0 and id = cnts then id
     else id - 1 end as id,
     student from seat,
     (select count(*) as cnts from seat) b
     order by id
--  这里计算id有多少只能写subquery，而不能用max(id)
-- 我们这里需要另外开一个subquery来计算到底总共有多少行


-- 我是真的不太想再纠结subquery的问题了，所以直接用cte来解决
-- 这里其实我们纠结的点在：到底整个id list是奇数还是偶数，如果是偶数，那么什么都不需要犹豫，但是如果是奇数，最后一个位置是不变的
-- 那么我们纠结点在于奇数的问题，那么在case when我们不必去考虑偶数问题，因为偶数无论如何都是id - 1的情况
-- 那么对于奇数的情况，我们要讨论的就是：到底最后一个位置是否是奇数
with num_seats as
(select count(id) as cnt from seat)

select 
case when mod(id,2) != 0 and id != cnt then id + 1
when mod(id,2) != 0 and id = cnt then id
else id - 1 end as id, 
student
from seat,num_seats
order by 1


/*
这一道题如果写成下面这种情况那么就有问题了
select 
(case when id%2 != 0 and id != count then id + 1
when id%2 = 0 and id != count then id - 1
else id end) as id,student from seat,
(select count(*) as count from seat)tmp
order by id

有问题的原因在于，如果是偶数个，那么最后一个是不会有变化的
Input:
{"headers": {"seat": ["id","student"]}, "rows": {"seat": [[1,"Abbot"],[2,"Doris"],[3,"Emerson"],[4,"Green"],[5,"Jeames"],[6,"Julia"]]}}
Output:
{"headers": ["id", "student"], "values": [[1, "Doris"], [2, "Abbot"], [3, "Green"], [4, "Emerson"], [6, "Jeames"], [6, "Julia"]]}
Expected:
{"headers":["id","student"],"values":[[1,"Doris"],[2,"Abbot"],[3,"Green"],[4,"Emerson"],[5,"Julia"],[6,"Jeames"]]}
*/