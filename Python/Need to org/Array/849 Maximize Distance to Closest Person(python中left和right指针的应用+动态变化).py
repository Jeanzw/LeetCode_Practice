seats = [1,0,0,0,1,0,1]
occu = []
for i in range(len(seats)):
    print(i)
    if seats[i] == 1:
        occu.append(i)
print(occu)
#上面步骤就是说我们把已经坐了人的index给记录下来

can_seat = []
for j in range(len(occu) - 1):
    #print(occu[j])
    for q in range(occu[j],occu[j + 1]):
        if occu[j] != q:
            #print(q)
            can_seat.append(q)
#我们将没有坐人的index给记录下来

if occu == [0]:  #我们来考虑00001这种情况
    can_seat = len(seats) - 1

print(can_seat)
#我们上面的步骤是错误的：
#我们只是把坐人以及没有坐人的index给记录下来，但是我们并没有来看其之间的距离是多少



#Gang的思路：
#其实整个字符串只有三种组成：
#1.  100000
#2.  000001
#3.  100001
class Solution(object):
    def maxDistToClosest(self, seats):
        """
        :type seats: List[int] 
        :rtype: int
        """
        dist = 0
        i=0  #这里相当于是index
        while i < len(seats) and seats[i] != 1:  #这里我们其实就是在扫为0的数字，其实就是第二种情况
            i +=1  #如果没有1出现，那么就一直往右边扫，直到扫到了1，那么距离就是第一个0到第一个1出现的距离
            #这里的i既可以作为index，也可以作为距离的计数
        if i < len(seats) and seats[i] == 1:
            dist = max(dist, i)
        
        
        #如果不是第二种情况，那么我们上面的while和if就会跳过，然后进入下一部分
            #我们这一部分都是以1开头，也就是第一和第三种情况
            #如果是第一或者第三种情况，那么我们其实就算走了上面的while和if也没有关系，因为还是0
            #就算是0000010000这种情况我们也不怕，因为我们就可以看作是第二种情况和第一种情况的结合，我们在10000这一部分的时候，还是看作此处的1是第一个出现的情况
        left = i
        right = i+1   #这里我们用left和right来当做指针，初始化left = i 
        while right < len(seats):
            while right < len(seats) and seats[right]!=1:
                    right += 1  #这里我们用right指针来确认下一个1出现的位置，只要没有出现，那么就继续往后扫
            if right <len(seats) and seats[right] ==1:
                    dist = max(dist, (right-left)//2)  #找到了两个1之后，其实里面的最大最近距离就是：(right-left)//2，因为//是取整，所以奇偶结果是一样的
            if right < len(seats):  
                    left = right  #当我们找到了下一个1的时候，那么就更新一下left和right
                    right +=1  #然后right继续往右扫
        #我们这里又一个容易出错的地方就是，while和for是不同的，只要满足while的条件，那么就一直在里面，不做任何变化
        #所以我们在最大的while里面可以肆意游荡
        #小while里面可以肆意扫，直到扫出了我们要的，再分别进行两个if的操作

        if right == len(seats):  #当right == len(seats)的时候就说明已经扫完了，但是index多出来了一个，所以在计算distance的时候要减去1
            dist = max(dist, right-left-1)
        
        return dist
