select business_id from Events a
left join (select event_type,avg(occurences) as average from Events
          group by event_type)b
on a.event_type = b.event_type
where a.occurences > average
group by a.business_id
having count(*) > 1