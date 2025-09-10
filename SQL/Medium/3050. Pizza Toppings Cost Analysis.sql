select
concat_ws(',',a.topping_name,b.topping_name,c.topping_name) as pizza,
a.cost + b.cost + c.cost as total_cost
from Toppings a
inner join Toppings b 
inner join Toppings c 
on a.topping_name < b.topping_name
and b.topping_name < c.topping_name
order by 2 desc, 1

------------------------------

-- Python
import pandas as pd

def cost_analysis(toppings: pd.DataFrame) -> pd.DataFrame:
    merge = pd.merge(toppings,toppings, how = 'cross').merge(toppings, how = 'cross')
    merge = merge[(merge['topping_name_x'] < merge['topping_name_y']) & (merge['topping_name_y'] < merge['topping_name'])]
    -- 关键问题：'topping_name_x' < 'topping_name_y' < 'topping_name' 不等价于“按字母顺序排列后再拼接”
    merge['pizza'] = merge['topping_name_x'] + ',' + merge['topping_name_y'] + ',' + merge['topping_name']
    merge['total_cost'] = merge['cost_x'] + merge['cost_y'] + merge['cost']
    return merge[['pizza','total_cost']].sort_values(['total_cost','pizza'],ascending = [0,1])

-- 修改如下
import pandas as pd

def cost_analysis(toppings: pd.DataFrame) -> pd.DataFrame:
    # step 1: cross join
    merge = pd.merge(toppings, toppings, how='cross').merge(toppings, how='cross')

    # step 2: 排除重复组合（按 topping_name 字母顺序）
    merge = merge[
        (merge['topping_name_x'] < merge['topping_name_y']) & 
        (merge['topping_name_y'] < merge['topping_name'])
    ]

    # step 3: pizza 名必须字母顺序拼接
    merge['pizza'] = merge.apply(
        lambda row: ",".join(sorted([
            row['topping_name_x'],
            row['topping_name_y'],
            row['topping_name']
        ])),
        axis=1
    )

    # step 4: 计算 cost，保留两位小数
    merge['total_cost'] = (
        merge['cost_x'] + merge['cost_y'] + merge['cost']
    ).round(2)

    # step 5: 排序输出
    return merge[['pizza','total_cost']].sort_values(['total_cost','pizza'],ascending=[False, True]).reset_index(drop=True)

