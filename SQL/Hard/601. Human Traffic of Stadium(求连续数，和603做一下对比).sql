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