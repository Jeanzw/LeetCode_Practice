-- 下面这一个代码是我自己写的，相当于我们先把各个player_id的最小日期求出来，然后找和最小日期相差天数只有一天的日期和player_id，计算出来当做分子top，然后再计算有多少个player_id当做分母，然后在最开头用分子除以分母
with firstlogin as
(select player_id, min(event_date) as first_login 
from Activity group by 1)
,top as
(select count(distinct a.player_id) as top from Activity a 
inner join firstlogin f on a.player_id = f.player_id and datediff(a.event_date,first_login) = 1)
,bottom as 
(select count(distinct player_id) as bottom from Activity)

select round(top/bottom,2) as fraction from top,bottom


-- 我们现在把上面的这一个解法做一个拆解如此便于我们更好理解该题：
-- 第一步：
-- 由于我们想要知道的事在第一次log之后的第二天是否有log，那么我们先找出每个player的第一天登录的时间
select player_id,min(event_date) as min_date from Activity
group by player_id
-- 在我们找到第一次登录的事件之后，我们需要去找有哪些player第二天也登陆了，而这些玩家的数量就是我们的分子
-- 为了找到这些player我们当然可以用left join，但是既然我们只要找到交集，那么直接用inner就好了,对于我们的例子，输出的是1，这个是正确的
select count(distinct a.player_id) as top from Activity a inner join
(select player_id,min(event_date) as min_date from Activity
group by player_id)b
on a.player_id = b.player_id and a.event_date - 1 = b.min_date
-- 而当我们找到分子之后，我们接下来要来找分母了，分母其实非常简单，就是直接计算player的数量就好了,于是就构成了我们的答案
select round(top/bottom,2) as fraction from

(
select count(distinct a.player_id) as top from Activity a inner join
(select player_id,min(event_date) as min_date from Activity
group by player_id)b
on a.player_id = b.player_id and a.event_date - 1 = b.min_date
    ) c,

(select count(distinct player_id) as bottom from Activity)d