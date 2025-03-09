select
round(sum(item_count * order_occurrences)/sum(order_occurrences),2) as average_items_per_order
from Orders

-----------------------

-- Python
import pandas as pd

def compressed_mean(orders: pd.DataFrame) -> pd.DataFrame:
    orders['sum_orders'] = orders['item_count'] * orders['order_occurrences']
    n = orders.sum_orders.sum()
    d = orders.order_occurrences.sum()
    average_items_per_order = round(n/d,2)
    return pd.DataFrame({'average_items_per_order':[average_items_per_order]})