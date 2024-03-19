with first_ as
(select first_col, row_number() over (order by first_col) as rnk from Data)
, second_ as 
(select second_col, row_number() over (order by second_col desc) as rnk from Data)

select first_col,second_col
from first_ a
left join second_ b on a.rnk = b.rnk