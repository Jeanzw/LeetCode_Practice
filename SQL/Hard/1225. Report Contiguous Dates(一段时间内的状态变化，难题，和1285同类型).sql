/*
首先肯定还是先把成功失败表给union all联合起来，
然后这里涉及一个新的知识点dateadd()：https://www.w3school.com.cn/sql/func_dateadd.asp

select period_state,date,rank,dateadd(day, -rank, date) from
(
(select 'failed' as period_state, fail_date as date,row_number() over (order by fail_date) as rank from Failed
where fail_date >= '2019-01-01' and fail_date <= '2019-12-31')
union all
(select 'succeeded' as period_state, success_date as date,row_number() over (order by success_date) as rank from Succeeded
where success_date >= '2019-01-01' and success_date <= '2019-12-31'))tmp

进行了上述操作之后，我们得出的结果就是：
{"headers": ["period_state", "date", "rank", ""], 
"values": [["failed", "2019-01-04", 1, "2019-01-03"], 
          ["failed", "2019-01-05", 2, "2019-01-03"], 
          ["succeeded", "2019-01-01", 1, "2018-12-31"], 
          ["succeeded", "2019-01-02", 2, "2018-12-31"], 
          ["succeeded", "2019-01-03", 3, "2018-12-31"], 
          ["succeeded", "2019-01-06", 4, "2019-01-02"]]}

这里我们其实可以看出，dateadd列如果是一样的内容其实是一伙的，那么我们到最后肯定是要group by他们的
而后我们还需要group by的是period_state
*/


-- dateadd()只用在ms sql中，mysql没有这个function
select period_state,min(date) as start_date,max(date) as end_date from
(
(select 'failed' as period_state, fail_date as date,row_number() over (order by fail_date) as rank from Failed
where fail_date >= '2019-01-01' and fail_date <= '2019-12-31')
union all
(select 'succeeded' as period_state, success_date as date,row_number() over (order by success_date) as rank from Succeeded
where success_date >= '2019-01-01' and success_date <= '2019-12-31'))tmp

group by period_state,dateadd(day,-rank,date)
order by start_date

---------------------------------

-- 我们对上面的内容进行修改一下
with rawdata as
(select
'fail' as status,
fail_date as day
from Failed
union all
select 
'success' as status,
success_date as day
from Succeeded)
-- 这个cte我们直接处理成统一的表

select status, min(day) as start_date,max(day) as end_date from
(select
*,
row_number() over (partition by status order by day) as rnk
-- 我们的rank需要针对每个部分自己有一个rank，而不能统一的rank
-- 因为类似于题目给的例子，其实succeeded和failed是连续的，如果我们针对所有的日期进行排序，那么其实第二段success和第一段success之间，通过day - rnk其实是没有差别的
-- 那么当我们用group by的时候，第二段和第一段success其实系统是没办法区别的，就会自动将这两段合在一起
-- 而这个肯定不是我们想要的
from rawdata
where day between '2019-01-01' and '2019-12-31')tmp
group by status, dateadd(day,- rnk ,day)
order by start_date

---------------------------------

-- 如果要在mysql中处理，那么我们在group by之前需要处理一下
SELECT stats AS period_state, MIN(day) AS start_date, MAX(day) AS end_date
FROM (
    SELECT 
        day, 
        RANK() OVER (ORDER BY day) AS overall_ranking, 
        stats, 
        rk, 
        (RANK() OVER (ORDER BY day) - rk) AS inv
        -- 因为没有dateadd使用，所以在这里我们只能用rnk来进行处理一下
    FROM (
        SELECT fail_date AS day, 'failed' AS stats, RANK() OVER (ORDER BY fail_date) AS rk
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        UNION 
        SELECT success_date AS day, 'succeeded' AS stats, RANK() OVER (ORDER BY success_date) AS rk
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31') t
    ) c
GROUP BY inv, stats
ORDER BY start_date

---------------------------------

-- Python
import pandas as pd

def report_contiguous_dates(failed: pd.DataFrame, succeeded: pd.DataFrame) -> pd.DataFrame:
    failed['period_state'] = 'failed'
    failed = failed.rename(columns = {'fail_date':'dt'})
    succeeded['period_state'] = 'succeeded'
    succeeded = succeeded.rename(columns = {'success_date':'dt'})
    concat = pd.concat([failed,succeeded])

    concat = concat[concat['dt'].dt.year == 2019]
    concat['rnk'] = concat.groupby(['period_state']).dt.rank()
    concat['bridge'] = concat['dt'] - pd.to_timedelta(concat['rnk'],unit ='d')

    res = concat.groupby(['period_state','bridge'],as_index = False).agg(
        start_date = ('dt','min'),
        end_date = ('dt','max')
    )
    return res[['period_state','start_date','end_date']].sort_values('start_date')