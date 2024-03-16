with subscription_2021 as
(select
distinct account_id
from Subscriptions
where year(start_date) = 2021 or year(end_date) = 2021 or (year(start_date) < 2021 and year(end_date) > 2021))
, session_2021 as
(select distinct account_id from Streams where year(stream_date) = 2021)

select
count(distinct a.account_id) as accounts_count
from subscription_2021 a
left join session_2021 b on a.account_id = b.account_id
where b.account_id is null