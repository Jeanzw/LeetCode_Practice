/*这里考察的就是union的用法，其实我们相当于重新建立一张表，
然后把accepter_id当做一般的id拼接在requester_id下面，然后进行计算
union和union all的区别：
https://juejin.im/post/5c131ee4e51d45404123d572
效率：UNION和UNION ALL关键字都是将两个结果集合并为一个，但这两者从使用和效率上来说都有所不同。
1、对重复结果的处理：UNION在进行表链接后会筛选掉重复的记录，Union All不会去除重复记录。
2、对排序的处理：Union将会按照字段的顺序进行排序；UNION ALL只是简单的将两个结果合并后就返回。

从效率上说，UNION ALL 要比UNION快很多
所以，如果可以确认合并的两个结果集中不包含重复数据且不需要排序时的话，那么就使用UNION ALL。
*/
select id, count(*) as num
from
(select requester_id as id from request_accepted
union all   
select accepter_id as id from request_accepted) as new
group by id
order by count(*) desc limit 1




select id,count(*) as num from
(select requester_id as id from request_accepted
union all
select accepter_id as id from request_accepted)tmp
group by 1
order by 2 desc limit 1
