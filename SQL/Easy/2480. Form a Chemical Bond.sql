select
a.symbol as metal,
b.symbol as nonmetal
from Elements a, Elements b
where a.type = 'Metal' and b.type = 'Nonmetal'


-- Python
import pandas as pd

def form_bond(elements: pd.DataFrame) -> pd.DataFrame:
    metal = elements[elements['type'] == 'Metal'][['symbol']]
    nonmetal = elements[elements['type'] == 'Nonmetal'][['symbol']]
    merge = pd.merge(metal,nonmetal,how = 'cross')
    return merge.rename(columns = {'symbol_x':'metal','symbol_y':'nonmetal'})