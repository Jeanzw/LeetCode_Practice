-- 我的方法：
-- 如果只有一条数据那么它就自己走
-- 如果不是，那么就用rank进行排序
select * from UserActivity where username in
(select username from UserActivity 
group by 1
having count(*) = 1)

union all

select username,activity,startDate,endDate from
(select *, rank() over (partition by username order by startDate desc) as rnk from UserActivity)tmp
where rnk = 2



-- 别人的方法
select username, activity, startDate, endDate
from (
select *, count(activity) over(partition by username)cnt, 
ROW_NUMBER() over(partition by username order by startdate desc) n from UserActivity) tbl
where n=2 or cnt<2