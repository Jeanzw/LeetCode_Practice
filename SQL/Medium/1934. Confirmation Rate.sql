select
    s.user_id,
    round(ifnull(sum(case when action = 'confirmed' then 1 else 0 end)
    /
    count(*) , 0),2) as confirmation_rate
    from Signups s
    left join Confirmations c on s.user_id = c.user_id
    group by 1