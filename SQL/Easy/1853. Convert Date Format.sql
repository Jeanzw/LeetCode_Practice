-- mysql
-- These are macros or formats for date and time
-- Listed below some supported formats (check MySQL documentation regarding to the full list or new updates).

-- %e - useful when you need to use day without leading zero. 1 January, 9 March etc. otherwise use %d
-- %W - day of week in full, there is format %a, but it's abbreviation as Mon, Tue, etc.
-- %M the same name in full
-- %Y - full year

-- Date format most preferable instead of specific functions as DAYNAME Function when you want to concat string, add space, characters and so on

-- %D Day of the month as a numeric value, followed by suffix (1st, 2nd, 3rd, ...)
-- %d Day of the month as a numeric value (01 to 31)
-- %e Day of the month as a numeric value (0 to 31)
-- %M Month name in full (January to December)
-- %m Month name as a numeric value (00 to 12)
-- %W Weekday name in full (Sunday to Saturday)
-- %w Day of the week where Sunday=0 and Saturday=6
-- %Y Year as a numeric, 4-digit value
-- %y Year as a numeric, 2-digit value
select date_format(day,'%W, %M %e, %Y') as day from Days



-- ms sql
SELECT format(day,'D') AS day FROM Days



-- oracle
SELECT TO_CHAR(Day,'fmDay, fmMonth fmdd, YYYY') AS day FROM Days



-- Python
import pandas as pd

def convert_date_format(days: pd.DataFrame) -> pd.DataFrame:
    days['day'] = days['day'].dt.strftime('%A, %B %-d, %Y')
    return days