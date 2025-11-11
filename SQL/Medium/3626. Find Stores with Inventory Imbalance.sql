with cte as
(select
a.store_id,
a.store_name,
a.location,
b.product_name,
b.quantity,
row_number() over (partition by a.store_id order by b.price desc) as rnk_desc,
row_number() over (partition by a.store_id order by b.price ) as rnk,
count(b.product_name) over (partition by a.store_id ) as cnt
from stores a
join inventory b on a.store_id = b.store_id)

select
a.store_id,
a.store_name,
a.location,
a.product_name as most_exp_product,
b.product_name as cheapest_product,
round(b.quantity/a.quantity,2) as imbalance_ratio
from cte a
join cte b on a.store_id = b.store_id and a.rnk_desc = 1 and b.rnk = 1 and a.quantity < b.quantity
where a.cnt >= 3
order by 6 desc, 2

-- Python
import pandas as pd

def find_inventory_imbalance(stores: pd.DataFrame, inventory: pd.DataFrame) -> pd.DataFrame:
    inventory['cnt'] = inventory.groupby(['store_id']).product_name.transform('nunique')
    inventory = inventory[inventory['cnt'] > 2]
    inventory['rnk'] = inventory.groupby(['store_id']).price.rank(method = 'first')
    inventory['rnk_desc'] = inventory.groupby(['store_id']).price.rank(method = 'first', ascending = False)

    top = inventory[inventory['rnk_desc'] == 1]
    bottom = inventory[inventory['rnk'] == 1]

    inv = pd.merge(top, bottom, on = 'store_id')
    inv = inv[inv['quantity_x'] < inv['quantity_y']][['store_id','product_name_x','product_name_y','quantity_x','quantity_y']]
    inv['imbalance_ratio'] = round(inv['quantity_y']/inv['quantity_x'],2)

    res = pd.merge(stores, inv, on = 'store_id')[['store_id','store_name','location','product_name_x','product_name_y','imbalance_ratio']]

    return res.rename(columns = {'product_name_x':'most_exp_product','product_name_y':'cheapest_product'}).sort_values(['imbalance_ratio','store_name'], ascending = [0,1])