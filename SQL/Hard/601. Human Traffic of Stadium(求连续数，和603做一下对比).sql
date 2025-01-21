-- 之所以我们需要在on的时候颠来倒去那是因为我们知识要抽出a的内容

select distinct a.* from stadium a
 join stadium b
 join stadium c
on (a.id + 1 = b.id and a.id + 2 = c.id) 
or (b.id + 1 = c.id and b.id + 2 = a.id) 
or (c.id + 1 = a.id and c.id + 2 = b.id)
where a.people >= 100 and b.people >= 100 and c.people >= 100
order by id


-- 第二次的做法我是先在最开始对原数据做了一个处理，剔除掉了小于100的内容，但其实原理是一样的
-- 但是我仍旧犯的一个问题是，对于join之后的处理
-- 到底我们应该选择join还是left join？
-- 而且我最开始的时候就默认r1是第一个，r2是第二个，r3是第三个
-- 这样处理出现的问题就是那么对于id = 8来说，其实在这个过程中我们是找不到它之后的连续两个数
with raw as
(select * from Stadium where people >= 100)

select distinct r1.* from raw r1
join raw r2 
join raw r3 
on (r1.id + 1 = r2.id and r1.id + 2 = r3.id)
or (r2.id + 1 = r3.id and r2.id + 2 = r1.id)
or (r3.id + 1 = r1.id and r3.id + 2 = r2.id)
order by visit_date




-- 这道题也可以按照常规套路，就是用group by来做，只是相对比较麻烦
with diff as
(select 
    id,
    visit_date,
    people,
    id - row_number() over(order by id) as bridge
    from Stadium
    where people >= 100)

select id,visit_date,people from diff
where bridge in (select bridge from diff group by 1 having count(*) >= 3)
-- 这里我们之所以用in不用原本consecutive的常见套路group by A，B是因为，这里根本没有A呀……
-- 我们之前的两个group by中的第一个A是因为是在对某个固定群体先group by起来，但是这里，因为people其实都是> 100的，那么其实是没有对应的固定群体的



-- 这道题和#180的对比：
-- #180需要求出来对应的数就好，而不是需要把所有的id以及num全部列出来
-- 但是#601不是说把对应的某个数字列出来，而是要求把连续出现的行数全部打出来
-- 那么我们需要的就是先把id - rnk这个可以作为链接的数给求出来，然后用in来筛选出来满足条件的行


-- Python
import pandas as pd

def human_traffic(stadium: pd.DataFrame) -> pd.DataFrame:
    stadium = stadium.query("people >= 100")
    stadium['rnk'] = stadium.visit_date.rank()
    stadium['bridge'] = stadium['id'] + 1 - stadium['rnk']

    bridge = stadium.groupby(['bridge'],as_index = False).id.nunique()
    bridge = bridge.query("id >= 3")[['bridge']]

    res = pd.merge(stadium,bridge,on = 'bridge')
    return res[['id','visit_date','people']].sort_values('visit_date')



-- 另外的做法，我不用groupby，直接用transform找到对应的bridge数量，然后直接处理
import pandas as pd

def human_traffic(stadium: pd.DataFrame) -> pd.DataFrame:
    stadium = stadium[stadium['people'] >= 100]
    stadium['bridge'] =  stadium['id'] + 1 - stadium.id.rank()
    stadium['cnt_bridge'] = stadium.groupby(['bridge']).id.transform('nunique')
    
    stadium = stadium[stadium['cnt_bridge'] >= 3]
    return stadium[['id','visit_date','people']].sort_values('visit_date')