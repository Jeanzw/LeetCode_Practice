select
concat_ws(',',a.topping_name,b.topping_name,c.topping_name) as pizza,
a.cost + b.cost + c.cost as total_cost
from Toppings a
inner join Toppings b 
inner join Toppings c 
on a.topping_name < b.topping_name
and b.topping_name < c.topping_name
order by 2 desc, 1