#下面这一个代码是我自己写的，相当于我们先把各个player_id的最小日期求出来，然后找和最小日期相差天数只有一天的日期和player_id，计算出来当做分子top，然后再计算有多少个player_id当做分母，然后在最开头用分子除以分母
select round(top/bottom,2) as fraction from

(select count(distinct a.player_id) as top from Activity as a,
(select player_id,min(event_date) as min_date from Activity
group by player_id) as b
where a.player_id = b.player_id and datediff(a.event_date,min_date) = 1)c,

(select count(distinct player_id) as bottom from Activity)d
