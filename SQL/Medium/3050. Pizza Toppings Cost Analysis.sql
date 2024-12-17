select
concat_ws(',',a.topping_name,b.topping_name,c.topping_name) as pizza,
a.cost + b.cost + c.cost as total_cost
from Toppings a
inner join Toppings b 
inner join Toppings c 
on a.topping_name < b.topping_name
and b.topping_name < c.topping_name
order by 2 desc, 1


-- Python
import pandas as pd

def cost_analysis(toppings: pd.DataFrame) -> pd.DataFrame:
    toppings['rnk'] = toppings.topping_name.rank()
    merge = pd.merge(toppings,toppings,how = 'cross').merge(toppings, how = 'cross')

    merge = merge[(merge['rnk_x'] < merge['rnk_y']) & (merge['rnk_y'] < merge['rnk'])]
    merge['pizza'] = merge['topping_name_x'] + ',' + merge['topping_name_y'] + ',' + merge['topping_name']
    merge['total_cost'] = merge['cost_x'] + merge['cost_y'] + merge['cost'] 
    return merge.sort_values(['total_cost','pizza'], ascending = [0,1])[['pizza','total_cost']]

