with recursive framework as
(select 1 as start, 6 as end, 1 as interval_no
union all
select start + 6 as start, end + 6 as end, interval_no + 1 as interval_no 
from framework
where start + 6 < (select max(minute) from Orders)
)

select
a.interval_no,
sum(order_count) as total_orders
from framework a
left join Orders b on b.minute between a.start and a.end
group by 1
order by 1