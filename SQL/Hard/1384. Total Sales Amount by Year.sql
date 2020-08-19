SELECT a.product_id, b.product_name, a.report_year, a.total_amount
FROM (
    SELECT product_id, '2018' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2018-12-31'), GREATEST(period_start, '2018-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)=2018 OR YEAR(period_end)=2018

    UNION ALL

    SELECT product_id, '2019' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2019-12-31'), GREATEST(period_start, '2019-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)<=2019 AND YEAR(period_end)>=2019

    UNION ALL

    SELECT product_id, '2020' AS report_year,
        average_daily_sales * (DATEDIFF(LEAST(period_end, '2020-12-31'), GREATEST(period_start, '2020-01-01'))+1) AS total_amount
    FROM Sales
    WHERE YEAR(period_start)=2020 OR YEAR(period_end)=2020
) a
LEFT JOIN Product b
ON a.product_id = b.product_id
ORDER BY a.product_id, a.report_year





-- 另一种做法
select cast(P.product_id as varchar) PRODUCT_ID, product_name PRODUCT_NAME, report_year REPORT_YEAR, amount TOTAL_AMOUNT from Product P
left join

(select product_id, '2018' report_year, (1+datediff(day, period_start, (case when period_end < '2019-01-01' then period_end else '2018-12-31' end) )) average_daily_sales amount
from Sales
union all
select product_id, '2019' report_year,
(1+datediff(day, (case when period_start < '2019-01-01' then '2019-01-01' else period_start end), (case when period_end < '2020-01-01' then period_end else '2019-12-31' end) ))* average_daily_sales amount
from Sales
union all
select product_id, '2020' report_year,
(1+datediff(day, (case when period_start < '2020-01-01' then '2020-01-01' else period_start end), (case when period_end < '2021-01-01' then period_end else '2020-12-31' end) ))* average_daily_sales amount
from Sales) T

on P.product_id = T.product_id
where amount >0
order by cast(P.product_id as varchar), report_year