-- 511：输出答案有最小日期的情况
select player_id, min(event_date) as first_login from Activity
group by player_id

-- 512：输出答案没有最小日期的情况
select player_id, device_id from Activity
where (player_id,event_date) in 
--这里的where里面用一个双重索引其实是我要去找最小的event_date，由于题目说了(player_id,event_date)这这组合是primary key，所以我就用这两者的组合进行检索
(select player_id,min(event_date) as event_date from Activity
group by player_id)