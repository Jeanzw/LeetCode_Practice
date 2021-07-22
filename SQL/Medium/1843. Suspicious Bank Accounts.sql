with exceed as
(select 
    date_format(day,'%Y%m') as month,
    t.account_id,
    case when sum(case when type = 'Creditor' then amount else 0 end) > max_income then 1 else 0 end as amount,
    row_number() over (partition by t.account_id order by date_format(day,'%Y-%m')) as rnk
    from Transactions t
    left join Accounts a on t.account_id = a.account_id
    group by 1,2
    having amount = 1)


select distinct account_id from exceed
group by 1,month-rnk
having count(*) > 1



-- 也有人是用join来判断连续两个月的
WITH summary AS
(
    SELECT t.account_id, SUM(t.amount) total_income, YEAR(day) Y, MONTH(day) M, a.max_income
    FROM Transactions t, Accounts a
    WHERE a.account_id = t.account_id
    AND type = 'Creditor'
    GROUP BY t.account_id, YEAR(day), MONTH(day)
    HAVING SUM(t.amount) > a.max_income
    ORDER BY t.transaction_id
)

SELECT DISTINCT s1.account_id
FROM summary s1 JOIN summary s2 ON s1.account_id = s2.account_id
WHERE (s1.M + 1 = s2.M AND s1.Y = s2.Y)
OR (s1.M = 12 AND s2.M = 1 AND s1.Y + 1 = s2.Y)
-- 最后的判断就是跨年还是不跨年，如果不跨年，那么我们让月份相差1，如果跨年那么就让年份+1同时月份有限制



-- 第三种方法是用period_diff ->返回二者之间的月份差
-- https://www.yiibai.com/mysql/mysql_function_period_diff.html
WITH temp AS (
SELECT t.account_id, DATE_FORMAT(day,'%Y%m') AS date, SUM(amount) AS 'income', Accounts.max_income
FROM Transactions t
LEFT JOIN Accounts ON Accounts.account_id=t.account_id
WHERE t.type='Creditor'
GROUP BY t.account_id, DATE_FORMAT(day,'%Y%m')
HAVING SUM(amount)>Accounts.max_income
)

SELECT t1.account_id
FROM temp t1, temp t2
WHERE t1.account_id=t2.account_id AND PERIOD_DIFF(t1.date, t2.date)=1
GROUP BY t1.account_id
ORDER BY t1.account_id