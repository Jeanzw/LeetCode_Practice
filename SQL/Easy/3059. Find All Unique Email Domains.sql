-- 这里考察的就是substring_index的应用，知道就会用，不知道就不会用
-- substring_index（'待截取有用部分的字符串'，'截取数据依据的字符'，截取字符的位置N）
-- 举个例子
-- 设待处理对象字符串为"15，151，152，16"
-- 这里截取的依据是逗号：','
-- 具体要截取第N个逗号前部分的字符

-- 取第一个逗号前的字符串:SUBSTRING_INDEX('15,151,152,16',',',1) -> 15

-- 截取第二个逗号前面部分:SUBSTRING_INDEX('15,151,152,16',',',2) -> 15,151

-- N可以为负数，表示倒数第N个索引字符后面的字符串。*有负号的时候，可以将整个字符倒过来看，依旧是第N个字符前面的部分。
-- 截取目标字符串中最后一个含 “，” 位子的后的部分: SUBSTRING_INDEX('15,151,152,16',',',-1) -> 16

SELECT 
  SUBSTRING_INDEX(email, '@', -1) AS email_domain, 
  COUNT(DISTINCT id) AS count 
FROM 
  Emails 
WHERE 
  email LIKE '%.com' 
GROUP BY 
  email_domain 
ORDER BY 
  email_domain asc;



-- Python
import pandas as pd

def find_unique_email_domains(emails: pd.DataFrame) -> pd.DataFrame:
    emails['end'] = emails['email'].str[-4:]
    emails = emails.query("end == '.com'")
    emails['email_domain'] = emails['email'].str.split('@').str[1]
    result = emails.groupby(['email_domain'], as_index = False).id.nunique()
    return result.rename(columns = {'id':'count'}).sort_values('email_domain')