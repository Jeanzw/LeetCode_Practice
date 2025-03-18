select
BIT_AND(permissions) as common_perms,
BIT_OR(permissions) as any_perms
from user_permissions

----------------

-- Python
import pandas as pd

def analyze_permissions(user_permissions: pd.DataFrame) -> pd.DataFrame:
    # 1. compute common_perms
    common_perms = np.bitwise_and.reduce(user_permissions['permissions'])
    # 2. compute any_perms
    any_perms = np.bitwise_or.reduce(user_permissions['permissions'])
    # 3. return res 
    return pd.DataFrame(data = [[common_perms, any_perms]], columns = ['common_perms', 'any_perms'])