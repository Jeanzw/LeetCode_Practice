/*
这道题的思路：
1.首先，我们按照continent划分对人按照人名进行排序
2.我们将排序的内容直接做成表格，这里需要用到case when，同时我们是按照这个排序进行分行的，所以对continent的case when需要用到max来进行处理，这样子才可以用group by
3.抽出来continent即可
*/


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


-- 另外一种解法：
select min(America) as America, min(Asia) as Asia, min(Europe) as Europe from  
--其实这里无所谓max还是min，最后都是可以得到一样的结果，因为这里我们其实知识想要抽出下面case的内容而已
    (select 
        row,
        case when continent = 'America' then name else null end as America,
        case when continent = 'Asia' then name else null end as Asia,
        case when continent = 'Europe' then name else null end as Europe
    from
        (select *,
        row_number() over(partition by continent order by name) as row
        from student) t1) t2
group by row;