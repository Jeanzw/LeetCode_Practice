select
concat(group_concat(term order by power desc separator ''), '=0') as equation
from (
select
CONCAT(case when factor > 0 then '+' else '' end, 
       factor, 
       case when power = 0 then '' else 'X' end, 
       case when power = 0 or power = 1 then '' else '^' end, 
       case when power = 0 or power = 1 then '' else power end
) term,
power
from
terms
order by power desc) t;



-- Python
import pandas as pd

def build_the_equation(terms: pd.DataFrame) -> pd.DataFrame:
    # 1. get sign and abs factors
    terms['sign'] = np.where(terms['factor'] > 0, '+', '-')
    terms['factor'] = abs(terms['factor'])
    # 2. get the power part and factor part respectively
    terms['power_part'] = 'X^' + terms['power'].astype({'power':'string'})
    terms['power_part'] = np.where(terms['power_part'] == 'X^1', 'X', 
                          np.where(terms['power_part'] == 'X^0', '', terms['power_part']))
    terms['factor_part'] = terms['sign'] + terms['factor'].astype({'factor':'string'})
    # 3. concat power part and factor part
    terms['concat_part'] = terms['factor_part'] + terms['power_part']
    # 4. sort the concat parts by power
    terms = terms.sort_values(by = 'power', ascending = False)
    # 5. Join all equations to create the final equation
    final_equation = ''.join(terms['concat_part']) + '=0'
    return pd.DataFrame(data = [[final_equation]], columns = ['equation'])