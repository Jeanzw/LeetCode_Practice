
WITH RECURSIVE  A AS(
    -- 首先先找到最末尾的tag，然后可能出现这种情况 #a xxxxxxxx，于是我们继续套用一个substring_index，仅把a给保留下来
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(tweet, "#", -1), " ", 1) AS tag,
    -- 我们利用LOCATE找到最后一个tag所在的位置（倒序），然后用tweet的长度减去这个位置就是最后一个tag在的（正序）位置
    SUBSTRING(tweet, 1, LENGTH(tweet) - LOCATE('#', REVERSE(tweet))) AS remain
    FROM Tweets
    UNION ALL
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(remain, "#", -1), " ", 1) AS tag,
    SUBSTRING(remain, 1, LENGTH(remain) - LOCATE('#', REVERSE(remain))) AS remain
    FROM A WHERE LOCATE('#', remain) > 0
),
B AS(
    SELECT CONCAT("#", tag) AS hashtag , COUNT(*) AS count  FROM A GROUP BY 1
)
SELECT * FROM B ORDER BY 2 DESC, 1 DESC LIMIT 3

