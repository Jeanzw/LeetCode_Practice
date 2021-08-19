select 
    date_format(trans_date,'%Y-%m') as month,
    country, 
    count(*) as trans_count,
    sum(case when state = 'approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount

from Transactions
group by month, country

-- 其实我个人还是会习惯在计数的时候不用1和0来计数，因为我们并不知道是否会有重复值
-- 所以我个人目前更倾向于还是保留id这个选项来进行计数
select
    date_format(trans_date,'%Y-%m') as month,
    country,
    count(distinct id) as trans_count,
    count(distinct case when state = 'approved' then id else null end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
    from Transactions
    group by 1,2