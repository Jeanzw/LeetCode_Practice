select
a.symbol as metal,
b.symbol as nonmetal
from Elements a, Elements b
where a.type = 'Metal' and b.type = 'Nonmetal'


-- Python
import pandas as pd

def form_bond(elements: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(elements,elements,how = 'cross')
    merge = merge.query("type_x == 'Metal' and type_y == 'Nonmetal'")
    return merge[['symbol_x','symbol_y']].rename(columns = {'symbol_x':'metal','symbol_y':'nonmetal'})