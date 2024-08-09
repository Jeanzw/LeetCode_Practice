select 
count(distinct customer_id) as rich_count
from Store
where amount > 500


-- Python
import pandas as pd

def count_rich_customers(store: pd.DataFrame) -> pd.DataFrame:
    store = store.query("amount > 500")
    rich_count = store['customer_id'].nunique()

    return pd.DataFrame({'rich_count':[rich_count]})