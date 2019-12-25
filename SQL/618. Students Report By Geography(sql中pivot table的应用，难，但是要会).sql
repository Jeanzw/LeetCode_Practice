SELECT America, Asia, Europe
FROM(
/*这一部分最后一定要group by continentorder，这样子才可以把同样等级的（第一序列）的给排到一起*/
SELECT continentorder,
MAX(CASE WHEN continent = 'America' THEN name END )AS America,
MAX(CASE WHEN continent = 'Europe' THEN name END )AS Europe,
MAX(CASE WHEN continent = 'Asia' THEN name END )AS Asia
FROM (
/*下面我们先把原表进行名字的排序，因为我们看结果，其实就是有排序的存在*/
SELECT *,
ROW_NUMBER()OVER(PARTITION BY continent ORDER BY name) AS continentorder
FROM student
) AS SOURCE
GROUP BY continentorder
)temp
