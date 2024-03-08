select
    date_id,
    make_name,
    count(distinct lead_id) as unique_leads,
    count(distinct partner_id) as unique_partners
    from DailySales
    group by 1,2


-- Python
import pandas as pd

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    # Approach: Group by Aggregation
    # Let us utilize the .groupby() method using 'date_id' and 'make_name'
    # as the grouping criterion and aggregate 'lead_id' and 'partner_id'
    # with methods 'nunique', which counts the unique elements within each group
    df = daily_sales.groupby(['date_id', 'make_name']).agg({
        'lead_id': 'nunique',
        'partner_id': 'nunique'
    }).reset_index()
    
    # Rename resulting DataFrame and rename columns
    df = df.rename(columns={
        'lead_id': 'unique_leads',
        'partner_id': 'unique_partners'
    })

    # Return DataFrame
    return df