select name,ifnull(sum(distance),0) as travelled_distance from Users a
left join Rides b on a.id = b.user_id
group by 1
order by 2 desc,1