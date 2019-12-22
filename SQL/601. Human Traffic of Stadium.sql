select distinct a.* from stadium a
 join stadium b
 join stadium c
on (a.id + 1 = b.id and a.id + 2 = c.id) or (b.id + 1 = c.id and b.id + 2 = a.id) or (c.id + 1 = a.id and c.id + 2 = b.id)
where a.people >= 100 and b.people >= 100 and c.people >= 100
order by id