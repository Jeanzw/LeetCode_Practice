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
select period_state,min(date) as start_date,max(date) as end_date from
(
(select 'failed' as period_state, fail_date as date,row_number() over (order by fail_date) as rank from Failed
where fail_date >= '2019-01-01' and fail_date <= '2019-12-31')
union all
(select 'succeeded' as period_state, success_date as date,row_number() over (order by success_date) as rank from Succeeded
where success_date >= '2019-01-01' and success_date <= '2019-12-31'))tmp

group by period_state,dateadd(day,-rank,date)
order by start_date