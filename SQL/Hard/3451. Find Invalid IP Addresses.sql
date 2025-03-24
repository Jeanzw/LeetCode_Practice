# Write your MySQL query statement below
with cte as
(select
*,
substring_index(ip,'.',1) as first_ip,
substring_index(substring_index(ip,'.',2),'.',-1) as second_ip,
substring_index(substring_index(ip,'.',3),'.',-1) as third_ip,
substring_index(ip,'.',-1) as fourth_ip
from logs)

select ip, count(*) as invalid_count
from cte
where first_ip > 255 or second_ip > 255 or third_ip > 255 or fourth_ip > 255
or ip like '%.0%'
or length(ip) - length(replace(ip,'.','')) != 3
group by 1
order by 2 desc, 1 desc

---------------------

-- Python
import pandas as pd

def find_invalid_ips(logs: pd.DataFrame) -> pd.DataFrame:
    def is_invalid(ip):
        parts = ip.split('.')
        # 条件 1：不是 4 个段
        if len(parts) != 4:
            return True
        for part in parts:
            # 条件 2：不是纯数字
            if not part.isdigit():
                return True
            # 条件 3：大于 255
            if int(part) > 255:
                return True
            # 条件 4：leading zero（但单独的 '0' 是合法的）
            if len(part) > 1 and part.startswith('0'):
                return True
        return False

    # 添加是否 invalid 的列
    logs['is_invalid'] = logs['ip'].apply(is_invalid)

    # 筛选出 invalid IP 并计数
    result = (
        logs[logs['is_invalid']]
        .groupby('ip')
        .size()
        .reset_index(name='invalid_count')
        .sort_values(by=['invalid_count', 'ip'], ascending=[False, False])
    )

    return result
