select player_id,min(event_date) as first_login from Activity
group by 1