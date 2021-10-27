-- 这道题关键在于弄懂题目意思，也就是说我们要保证timestamp是在starttime和endtime之间的
select distinct session_id
FROM Playback p
left join Ads a on p.customer_id = a.customer_id and a.timestamp between p.start_time and p.end_time
where a.customer_id is null