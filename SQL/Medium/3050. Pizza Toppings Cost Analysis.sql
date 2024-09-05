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
from itertools import combinations

def cost_analysis(toppings: pd.DataFrame) -> pd.DataFrame:
    # 1. Sort the toppings df
    toppings = toppings.sort_values(by = 'topping_name', ascending = True)
    # 2. Generate all possible combinations (a list of tuples) of 3 distinct toppings
    all_combinations_list = list(combinations(toppings['topping_name'], 3))
    # 3. Process topping names and concat and create a df
    res = pd.DataFrame(data = all_combinations_list, columns = ['A', 'B', 'C'])
    # 4. merge with original toppings table to get total cost
    res = res.merge(toppings, how = 'left', left_on = 'A', right_on = 'topping_name').merge(
        toppings, how = 'left', left_on = 'B', right_on = 'topping_name').merge(
            toppings, how = 'left', left_on = 'C', right_on = 'topping_name'
        )
    # 5. compute total_cost
    res['total_cost'] = round(res['cost_x'] + res['cost_y'] + res['cost'], 2)
    # 6. get pizza col
    res['pizza'] = res['A'] + ',' + res['B'] + ',' + res['C']
    return res[['pizza', 'total_cost']].sort_values(by = ['total_cost', 'pizza'], ascending = [False, True])