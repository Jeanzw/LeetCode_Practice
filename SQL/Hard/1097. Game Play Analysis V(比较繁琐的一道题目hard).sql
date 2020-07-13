/*
1.我们首先把每一个player的install_date给求出来
select player_id,min(event_date) as install_date from Activity
group by player_id

2.而后再将其与原表联合起来，来看看哪些是有第二天就继续上线的记录的
select * from
(select player_id,min(event_date) as install_date from Activity
group by player_id) a
left join Activity b
on a.player_id = b.player_id 
and a.install_date + 1 = b.event_date
我们会发现如果第二天不存在，那么在第二个date列会显示null
到目前为止，我们的总表就已经搞定了，接下来我们就要开始抽取我们想要的东西了
*/

select install_date as install_dt,
count(distinct a.player_id) as installs,
round(sum(case when b.event_date is not null then 1 else 0 end)
/
count(distinct a.player_id),2) as Day1_retention


from
(select player_id,min(event_date) as install_date from Activity
group by player_id) a
left join Activity b
on a.player_id = b.player_id 
and a.install_date + 1 = b.event_date


group by install_date