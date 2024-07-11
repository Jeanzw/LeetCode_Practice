select 
-- 要非常注意，分子是sum而不是count，不然永远都是6，因为一共有6个delivery_id需要判断
round(sum(order_date = customer_pref_delivery_date) * 100
/
count(delivery_id),2) as immediate_percentage
from Delivery


select
round( 
100 *
count(distinct case when order_date = customer_pref_delivery_date then delivery_id end)
/
count(distinct delivery_id),2) as immediate_percentage
from Delivery


-- Python
import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    is_valid = delivery['order_date'] == delivery['customer_pref_delivery_date']
    
    # Count the number of valid (immediate) orders and the number of all orders.
    valid_count = is_valid.sum()
    total_count = len(delivery)

    # Round the percentage to 2 decimal places.
    percentage = round(100 * valid_count / total_count, 2)

    df = pd.DataFrame({'immediate_percentage': [percentage]})
    return df



import pandas as pd

def food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    # 先去计算分母
    deno = delivery.delivery_id.count()
    # 确定好满足条件的行
    is_value = delivery['order_date'] == delivery['customer_pref_delivery_date']
    # 这里用sum()那么返回是false的就不计入，但是如果我们用count()那么无论返回false还是true都会被记录
    num = is_value.sum()
    res = round(100 * num/deno,2)
    # 由于我们这个res得到的是一个float，所以不能够直接返回return，如果我们要让其return返回，那么需要将其转变成dataframe的形式
    return pd.DataFrame({'immediate_percentage': [res]})