-- 仅用于ms sql
-- Here first LIKE checks that the mail starts with letter and ends with @leetcode.com, 
-- the second LIKE checks that the first part of the mail does not contain any symbol except allowed.

-- NOT LIKE '%[^0-9a-zA-Z_.-]%' -> means that the string does not contain any character except [0-9a-zA-Z_.-]
-- LIKE '%[0-9a-zA-Z_.-]%' -> means that the string contains at least one character from [0-9a-zA-Z_.-]

SELECT
    user_id,
    name,
    mail
FROM Users
WHERE mail LIKE '[a-zA-Z]%@leetcode.com' 
AND LEFT(mail, LEN(mail) - 13) NOT LIKE '%[^0-9a-zA-Z_.-]%'



-- Python
import pandas as pd

def valid_emails(users: pd.DataFrame) -> pd.DataFrame:
    pattern = r'^[A-Za-z][0-9A-Za-z_.-]*@leetcode\.com$'
    -- ^ / $ 表示整串必须完全匹配
    -- 第一位 [A-Za-z] 是字母
    -- [0-9A-Za-z_.-]* 允许的其余字符（星号表示 0 次或多次）
    -- @leetcode\.com 结尾（点要转义）
    df_valid = df[df['mail'].str.match(pattern, na=False)]
    return df_valid