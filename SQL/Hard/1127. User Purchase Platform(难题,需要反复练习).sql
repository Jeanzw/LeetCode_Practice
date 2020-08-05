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