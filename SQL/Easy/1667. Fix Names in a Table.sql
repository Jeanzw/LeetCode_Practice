select 
    user_id,
    concat(upper(left(name,1)),right(lower(name),length(name) - 1)) as name
    from Users
    order by 1

    -- 这里几个function：
    -- upper： 大写
    -- lower： 小写
    -- left：  从左边数
    -- right： 从右边数
    -- lenth： 求string的长度
    -- concat：将两个string给合并到一起


    -- Python
import pandas as pd

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    users["name"] = users["name"].str[0].str.upper() + users["name"].str[1:].str.lower()
    return users.sort_values("user_id")