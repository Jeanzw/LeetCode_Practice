with raw_data as
(select * from
(select from_id as person1, to_id as person2,duration from Calls
union all 
select to_id as person1, from_id as person2,duration from Calls)tmp
where person1 < person2)

select person1,person2,count(*) as call_count,sum(duration) as total_duration from raw_data
group by 1,2