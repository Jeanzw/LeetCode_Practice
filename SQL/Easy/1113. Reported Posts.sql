select extra as report_reason,count(distinct post_id) as report_count from Actions 
where action  = 'report' and action_date = '2019-07-05' - interval '1' day
group by 1