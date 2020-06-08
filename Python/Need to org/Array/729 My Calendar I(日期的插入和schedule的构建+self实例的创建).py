#Gang的思路就是：
#我们先放第一个日期，然后放之后的日期来通过前后日期的位置比较确认插入的部位
#这样子可以不用每一次加入新日期的时候都重新排序一遍
class MyCalendar(object):
    def __init__(self):  #这里相当于先创建一个实例
        self.calendar = []
#这里就是相当于attribute，因为是实例的属性，我们需要用self在开头
#虽然其意思仍旧是我们要创建一个名为calendar的空列表        

    def book(self, start, end):
        """
        :type start: int
        :type end: int
        :rtype: bool
        """
        pos = 0  #这里我们相当于是说最开始初始化一个位置
        for i in range(len(self.calendar)):  #我们这里的calendar是一个list,但是加进去的日期其实也是一个list
            if  not (end<=self.calendar[i][0]) and  not (start>=self.calendar[i][1]):  #这里就是我们要让end小于已经加入日期的最小日期，或者start大于已经加入日期的最大日期
                return False
            if self.calendar[i][1] <= start:
                    pos = i+1
            if self.calendar[i][0] >= end: #如果是这种情况，那么其实pos不变，因为新的日期肯定比calendar原本所有日期中的最小日期还要小，那么直接插入index = 0的时候就好了
                    break
        self.calendar.insert(pos, [start, end])  #按照pos的位置插入新的日期
        return True
