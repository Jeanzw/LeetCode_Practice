select num from my_numbers
group by num
having count(*) = 1
order by num desc limit 1

--上面是我原本的写法，这个写法一般没有问题，可是有一点，当我们没有这个数的时候，我们希望返回的是null而不是空值
--因为这个原因，我们只能用max，因为max会考虑空值
select max(num) as num from
(select num from my_numbers
group by num
having count(*) = 1) tno



-- Python
import pandas as pd

def biggest_single_number(my_numbers: pd.DataFrame) -> pd.DataFrame:
    # 1. Filter numbers that appear only once
    unique_numbers = my_numbers.groupby('num').filter(lambda x: len(x) == 1)
    
    # 2. Find the maximum of those numbers
    max_value = unique_numbers['num'].max()
    
    return pd.DataFrame({'num': [max_value]})
    