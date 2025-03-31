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



-- 我们之所以可以直接用limit这是因为题目中说了：It is guaranteed there is only 1 people having the most friends.
-- 如果没有说这一句话，那么我们是不能这么做的，只能先求出count最大的数，然后让我们的数和他的数一致
-- 或者直接用dense_rank
select id, count(*) as num
from
(select requester_id as id from request_accepted
union all   
select accepter_id as id from request_accepted) as new
group by id
order by count(*) desc limit 1

------------------------

-- 我觉得比较常规的方法应该如下图
-- 也就是说我们还是得先确定id和对应的friend
select id,count(friend) as num from
(select requester_id as id, accepter_id as friend from request_accepted
union
select accepter_id as id, requester_id as friend from request_accepted)tmp
group by 1
order by num desc
limit 1

------------------------

-- 最好用cte来写，不然太乱了
with cte as
(select requester_id as id, accepter_id as friend from RequestAccepted
union 
select accepter_id as id, requester_id as friend from RequestAccepted)

select id,count(distinct friend) as num from cte
group by 1
order by num desc
limit 1

------------------------

-- Python
import pandas as pd

def most_friends(request_accepted: pd.DataFrame) -> pd.DataFrame:
    list1 = request_accepted[['requester_id','accepter_id']].rename(columns = {'requester_id':'id','accepter_id':'num'})
    list2 = request_accepted[['accepter_id','requester_id']].rename(columns = {'accepter_id':'id','requester_id':'num'})
    concat = pd.concat([list1,list2])

    res = concat.groupby(['id'],as_index = False).num.nunique().sort_values('num')
    return res.tail(1)