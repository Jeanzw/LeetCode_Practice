/*
其实最简单的想法应该就是如下：
我们就设定如果group by之后计数为1，那么就直接platform的内容，如果计数为2，那么就说明是both，然后统计sum(amount)即可
可是这样做的问题在于，我们在7-2的时候其实是没有both的，所以结果没有返回both的情况，可是题目却要我们返回both的情况
尽管这个时候total_amount = 0 以及total_user = 0
SELECT 
    spend_date,
    platform,
    SUM(total_amount) AS total_amount,
    COUNT(DISTINCT user_id) AS total_users 
FROM

(select user_id,spend_date,
(case when count(*) = 1 then platform 
      when count(*) = 2 then 'both' end) as platform,sum(amount) as total_amount
      from Spending
      group by user_id,spend_date)tmp

GROUP BY spend_date,platform
order by spend_date




为了解决上述问题，我们肯定最开始首先要造出一个框架出来，也就是一定要有spend_date以及platform的框架要定调
用下面的方法，我们整体的框架基本就是：
{"headers": ["spend_date", "platform"], "values": 
            [["2019-07-01", "desktop"], 
            ["2019-07-01", "mobile"], 
            ["2019-07-01", "both"], 
            ["2019-07-02", "desktop"], 
            ["2019-07-02", "mobile"], 
            ["2019-07-02", "both"]]}


SELECT DISTINCT spend_date
FROM spending a
JOIN
(
    SELECT 'desktop' AS platform 
    UNION
    SELECT 'mobile' AS platform 
    UNION 
    SELECT 'both' AS platfrom) b 



接下来我们只需要将上两步left join就可以了

*/
--  最后我还是改成了下面的这种形式，这个是最符合我们讨论过程的时候写的逻辑的query了


select 
    p.spend_date,
    p.platform,
    ifnull(total_amount,0) as total_amount,
    ifnull(total_users,0) as total_users 
from
(SELECT DISTINCT(spend_date), 'desktop' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'mobile' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'both' platform FROM Spending)p

left join

--接下来的logic的目的其实就是很正常的的找出我们result想要的内容

(    SELECT 
    spend_date,
    platform,
    SUM(total_amount) AS total_amount,
    COUNT(DISTINCT user_id) AS total_users 
FROM

(select 
user_id,
spend_date,
(case when count(*) = 1 then platform 
      when count(*) = 2 then 'both' end) as platform,
      sum(amount) as total_amount
      from Spending
      group by user_id,spend_date)tmp

GROUP BY spend_date,platform
order by spend_date) o
on p.platform = o.platform and p.spend_date = o.spend_date

----------------------------------------------------------------------------------------

-- 上面的query修改一下就更容易理解了
with platform as
(select 'desktop' as platform
union 
 select 'mobile' as platform
union
 select 'both' as platform
)
, framework as
(select
s.spend_date,
 p.platform
 from (select distinct spend_date from Spending)s cross join platform p
)
-- 上面两个cte相当于去建立整个result的框架
, user_info as
(select
user_id,
spend_date,
case when count(distinct platform) = 1 then platform
when count(distinct platform) = 2 then 'both' end as platform,
sum(amount) as total_amount
from Spending
group by 1,2)
-- 最后一个cte相当于是不考虑框架直接对原表进行计算

select
f.*,
ifnull(sum(total_amount),0) as total_amount,
ifnull(count(distinct user_id),0) as total_users
from framework f
left join user_info u on f.platform = u.platform and f.spend_date = u.spend_date
group by 1,2

----------------------------------------------------------------------------------------

SELECT 
    p.spend_date,
    p.platform,
    IFNULL(SUM(amount), 0) total_amount,
    COUNT(user_id) total_users
FROM 
(
    SELECT DISTINCT(spend_date), 'desktop' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'mobile' platform FROM Spending
    UNION
    SELECT DISTINCT(spend_date), 'both' platform FROM Spending
) p 

--接下来的logic的目的其实就是很正常的的找出我们result想要的内容
LEFT JOIN (
    SELECT
        spend_date,
        user_id,
        IF(mobile_amount > 0, IF(desktop_amount > 0, 'both', 'mobile'), 'desktop') platform,
        (mobile_amount + desktop_amount) amount
    FROM (
        SELECT
          spend_date,
          user_id,
          SUM(CASE platform WHEN 'mobile' THEN amount ELSE 0 END) mobile_amount,
          SUM(CASE platform WHEN 'desktop' THEN amount ELSE 0 END) desktop_amount
        FROM Spending
        GROUP BY spend_date, user_id
    ) o
) t
ON p.platform=t.platform AND p.spend_date=t.spend_date
GROUP BY spend_date, platform

---------------------------------------------------------------------------------------

-- 再一次做的时候可以自己写出来，不过需要有些观念有改变的地方
with spend_date as
(select distinct spend_date from Spending)
,platform as
(select 'mobile' as platform
union all
 select 'desktop' as platform
union all
 select 'both' as platform
)
, date_platform as
(select * from spend_date,platform)
-- 我在上面两个cte相当于是建立了一个框架，可以让我保证拥有原表中所有的时间，同时有三列platform与之对应

, both_purchase as
(select user_id, spend_date,'both' as platform,sum(amount) as amount, count(distinct platform) as n from Spending
group by 1,2,3
having n = 2)
-- 这里我相当于是先把both的给抽出来

,purchase as
(select user_id, spend_date,platform,sum(amount) as amount from Spending
where (user_id,spend_date) not in (select user_id,spend_date from both_purchase)
 group by 1,2,3
 
 union all
 
 select user_id,spend_date,platform,amount from both_purchase
 
)
-- 然后用union all将single purchase和both purhcase的放在一起
-- 其实这里我们是可以直接用case when来将其分开的，这也就是我想的有点纰漏的地方

select 
    dp.spend_date,
    dp.platform, 
    ifnull(sum(amount),0) as total_amount,
    count(distinct user_id) as total_users
from date_platform dp
left join purchase p on dp.spend_date = p.spend_date and dp.platform = p.platform
group by 1,2
-- 而最后就是很简单的left join了

---------------------------------------------------------------------------------------

-- 再做一遍
with framework as
-- 首先把框架给搭起来，因为最后的output是无论是否有3种platform，但只要有对应的spend_date那么对应的platform就有三种
(select distinct spend_date, 'desktop' as platform from Spending
union all
select distinct spend_date, 'mobile' as platform from Spending
union all
select distinct spend_date, 'both' as platform from Spending
)
, users_info as
-- 把users自己的信息给确定好，比如说有几个platform
(select 
    user_id, 
    spend_date,
    case when count(distinct platform) = 1 then platform else 'both' end as platform,
    sum(amount) as amount
    from Spending 
    group by 1,2
    )

-- 最后整合两张表
select
a.spend_date,
a.platform,
ifnull(sum(amount),0) as total_amount,
count(distinct b.user_id) as total_users
from framework a
left join users_info b on a.spend_date = b.spend_date and a.platform = b.platform
group by 1,2

----------------------------------------------------------------------------------------

-- Python
import pandas as pd
import numpy as np

def user_purchase(spending: pd.DataFrame) -> pd.DataFrame:
    # 构建framework
    date_spend = spending[['spend_date']].drop_duplicates()
    platform = pd.DataFrame({'platform':['mobile','desktop','both']})
    frame = pd.merge(date_spend,platform,how = 'cross')
    # 计算
    spending['cnt'] = spending.groupby(['spend_date','user_id']).platform.transform('nunique')
    spending['platform'] = np.where(spending['cnt'] == 2, 'both',spending['platform'])
    spending = spending.groupby(['spend_date','platform'],as_index = False).agg(
        total_amount = ('amount','sum'),
        total_users = ('user_id','nunique')
    )
    # 将framework和计算结合
    merge = pd.merge(frame,spending,on = ['spend_date','platform'],how = 'left').fillna(0)
    return merge