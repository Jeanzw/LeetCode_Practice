UPDATE salary
SET
    sex = CASE sex
        WHEN 'm' THEN 'f'
        ELSE 'm'
    END;

------------------------------

UPDATE salary
SET 
sex = 
CASE WHEN sex = 'm' then 'f' else 'm' end

------------------------------

-- Python
import pandas as pd
import numpy as np
def swap_salary(salary: pd.DataFrame) -> pd.DataFrame:
    salary['sex'] = np.where(salary['sex'] == 'm','f','m')
    return salary