with recursive cte as
(select
*,
row_number() over () as rnk
from CoffeeShop)
, frame as
(select 
    id,
    drink,
    rnk 
from cte where rnk = 1

union all

select 
    b.id,
    case when b.drink is null then a.drink else b.drink end as drink,
    b.rnk 
from frame a join cte b on a.rnk + 1 = b.rnk
)

select id,drink from frame


-- Python
import pandas as pd

def change_null_values(coffee_shop: pd.DataFrame) -> pd.DataFrame:
    return coffee_shop.fillna(method='ffill')