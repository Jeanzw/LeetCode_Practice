select a.follower,count(distinct b.follower) as num from follow as a
left join follow as b on a.follower = b.followee
where b.follower is not null
group by b.followee
/*也可以不用left join，而直接用join求交集
但是无论如何，有一点容易错的地方就是count里面一定是distinct b.follower
这个才是每个followee真正的follower个数，不然就会出现重复的情况导致出错*/
select a.follower,count(distinct b.follower) as num from follow a 
join follow b
on a.follower = b.followee
group by b.followee
