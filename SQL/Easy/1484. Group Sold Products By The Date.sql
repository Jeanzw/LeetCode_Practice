-- mysql做法
SELECT sell_date,
		COUNT(DISTINCT(product)) AS num_sold, 
		GROUP_CONCAT(DISTINCT product ORDER BY product ASC SEPARATOR ',') AS products
        -- 这道题就属于，不知道group_concat那么就死都做不出来
FROM Activities
GROUP BY sell_date
ORDER BY sell_date ASC



-- MS SQL Server的做法
select sell_date, 
    COUNT(product) as num_sold,
    STRING_AGG(product,',') WITHIN GROUP (ORDER BY product) as products from
    -- STRING_AGG
    (select distinct sell_date,product FROM Activities) Act
    GROUP BY sell_date


-- Python
import pandas as pd

def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    groups = activities.groupby('sell_date')
    
    stats = groups.agg(
        num_sold=('product', 'nunique'), 
        products=('product', lambda x: ','.join(sorted(set(x))))
        ).reset_index()

    stats.sort_values('sell_date', inplace=True)

    return stats