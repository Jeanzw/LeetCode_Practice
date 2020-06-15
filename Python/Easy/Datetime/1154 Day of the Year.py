# 这道题的思路：
# 1. 将年月日拆开
# 2. 考虑一般情况下二月份是28天时的天数情况
# 3. 考虑闰年的情况
# 4. map(int, date.split('-'))  -> 拆年月日
# 5. sum(cnt[:m - 1]) -> 来统计除了该月之前的数量加和


#https://geekpy.github.io/2018/08/12/python_time/
#https://geekpy.github.io/2018/08/25/python_time2/
#https://geekpy.github.io/2019/03/02/pythontime3/
#Python 之 时间字符串、时间戳、时间差、任意时间字符串转换时间对象：https://www.cnblogs.com/liuq/p/6211005.html
#Python获取当前年月日：https://www.cnblogs.com/bovenson/p/6604803.html
#python中date、datetime、string的相互转换：https://www.cnblogs.com/cathouse/archive/2012/11/19/2777678.html
#Python时间日期操作大全：https://blog.csdn.net/yl2isoft/article/details/52077991
#Python中的时间模块：https://zhuanlan.zhihu.com/p/42631319

def ordinalOfDate(self, date):
    Y, M, D = map(int, date.split('-'))  #这相当于我们把年月日的string格式取出来
    return int((datetime.datetime(Y, M, D) - datetime.datetime(Y, 1, 1)).days + 1)


#上面是用了library，但是我们如果不用library：
class Solution:
    def dayOfYear(self, date: str) -> int:
        cnt = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] #这个是每个月一共有多少天
        y, m, d = map(int, date.split('-'))
        days = sum(cnt[:m - 1]) + d  #截止到这一步，我们基本能够把正常年份的情况给搞定了

        #但是我们知道，我们上面的2月份其实并没有考虑闰年的情况，所以接下来我们要考虑的就是闰年与否
        if m > 2:  
            if y % 400 == 0: days += 1
            if y % 100 == 0: return days
            if y % 4 == 0: days += 1
        return days



#另外的方法
class Solution:
    def dayOfYear(self, date: str) -> int:
        import datetime 
        date = datetime.datetime.strptime(date, '%Y-%m-%d')
        return date.timetuple().tm_yday  #d.timetuple().tm_yday    # 获取在一年中的第几天