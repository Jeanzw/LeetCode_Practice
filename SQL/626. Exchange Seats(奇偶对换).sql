SELECT
(case 
 when mod(id,2) != 0 and id != counts then id + 1
 when mod(id,2) != 0 and id = counts then id
 else id -1 end) as id, student
 from seat,
 (select count(*) as counts from seat) as temp
 order by id


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