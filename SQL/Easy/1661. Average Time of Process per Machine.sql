select 
    machine_id,
    -- process_id,
    round(sum(case when activity_type = 'end' then timestamp else -timestamp end)
    /
    count(distinct process_id),3)
    as processing_time
    from Activity group by 1

    -- 说实话，这道题一旦想通计算时间是用这个共识：((1.520 - 0.712) + (4.120 - 3.140))
    -- 那么很多问题就可以想通，无论process中间是否有间隔，只要我们把start定义为负数，end定义为正数，那么无论怎么变化，我们的原理都是求和