#这一道题其实就是datetime的应用：
#https://docs.python.org/3/library/calendar.html
#https://docs.python.org/3/library/datetime.html
#https://www.cnblogs.com/tkqasn/p/6001134.html

class Solution:
    def dayOfTheWeek(self, day: int, month: int, year: int) -> str:
        import datetime
        days_of_week = ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        date = datetime.datetime(year,month,day)
        num = date.weekday()
        return days_of_week[num]

#另外可以用到calendar library
import datetime, calendar

def dayOfTheWeek(self, d: int, m: int, y: int) -> str:
    return calendar.day_name[datetime.date(y, m, d).weekday()]



#另一种方法就是不用任何的library，就这么硬算，因为题目说了最早的是1971年，那么我们就从1971-1-1开始算
class Solution:
    def dayOfTheWeek(self, day: int, month: int, year: int) -> str:
        # 1971.1.1 is Friday

        runm = [0,31,29,31,30,31,30,31,31,30,31,30,31]
        notrunm = [0,31,28,31,30,31,30,31,31,30,31,30,31]
        
        days = {0:'Thursday',1:'Friday',2:'Saturday',3:'Sunday',4:'Monday',5:'Tuesday',6:'Wednesday'}
        
        dlen = 0
        
        yeard = year-1971
        
        runy = sum([y%4 == 0 for y in range(1971,year)])
        notruny = yeard-runy
        
        dlen+= runy*366 + notruny*365
        
        if year%4 == 0:
            dlen += sum(runm[:month])
        else:
            dlen += sum(notrunm[:month])
        
        dlen += day
        return days[dlen%7]