select distinct a.num as ConsecutiveNums
from Logs a   --注意，我们这里用的是inner join而不是left join 
inner join Logs b on b.id = a.id+1 and b.num = a.num
inner join Logs c on c.id = a.id+2 and c.num = a.num

--这里其实不是说不能用left join，而是如果用left join需要考虑为null的事情，而且如果用left join我们就是要选择最右边的数，而不是最左边的
select distinct c.Num as ConsecutiveNums  from Logs a
left join Logs b on a.Id - 1 = b.Id and a.Num = b.Num
left join Logs c on b.Id - 1 = c.Id and b.Num = c.Num
where c.Num is not null

-- 其实用left join也可以不考虑null的事情，直接a,b,c当作一个个增大的内容，然后我们取第一个，只需要保证数是一样的就好了
select distinct a.Num as ConsecutiveNums from Logs a
left join Logs b on a.Id + 1= b.Id 
left join Logs c on a.Id + 2 = c.Id 
where a.Num = b.Num and a.Num = c.Num  --可能会出现timeout的问题，但是重新来一次应该不会有问题了

--或者
select distinct a.Num as ConsecutiveNums from Logs a, Logs b, Logs c
where a.Id + 1 = b.Id
and b.Id + 1 = c.Id
and a.Num = b.Num and b.Num = c.Num

---------------------------------------

-- 为了响应连续数的第一种方法，我真是煞费苦心……
-- 这道题烦的一点就在于，可能存在的情况是Id从0开始的……
-- 所以我们为了保证group by里面的是正数，我们用了Id + 1 - rnk，这样子相当于把所有的Id都加1，确保Id是从1开始的
select distinct Num as ConsecutiveNums
from
(select
    Num,
    Id,
    rank() over (partition by Num order by Id) as rnk 
    from Logs) 
    tmp
    group by Num, Id + 1 - rnk  
    --这里 Id + 1 - rnk 是要有顺序的，我们必须保证从左到右计算要一直保证这个是正数
    -- 之所以是要Id + 1是因为有一个case的Id是从0开始的
    having count(*) >= 3

---------------------------------------

-- 或者这个处理直接在cte里面解决
with cte as
(select *, 1 + id - row_number() over (partition by num order by id) as bridge from Logs)
-- 我们要注意，rownumber里面是order by id不是order by num

select
distinct num as ConsecutiveNums
from cte
group by num, bridge
having count(*) >= 3

---------------------------------------

-- Python
import pandas as pd

def consecutive_numbers(logs: pd.DataFrame) -> pd.DataFrame:
    logs['bridge'] = logs['id'] + 1 - logs.groupby(['num']).id.rank(method = 'first')
    logs = logs.groupby(['num','bridge'], as_index = False).id.nunique()
    logs = logs[logs['id'] >= 3]
    return logs[['num']].rename(columns = {'num':'ConsecutiveNums'}).drop_duplicates()