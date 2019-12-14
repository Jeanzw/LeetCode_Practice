start = [0,0]
moves = "UD"
for i in moves:
    #print(i)
    if i == 'R':
        start[0] += 1
    if i == 'L':
        start[0] -= 1
    if i == 'U':
        start[1] += 1
    if i == 'D':
        start[1] -= 1
#print(start)
if start == [0,0]:
    print(True)
else:
    print(False)



#另一种解法：直接去用count()函数来计算个数
#这个的想法其实就很简单，只要我们上下相加为0，左右相加为0那么结果就是正确的了
print(moves.count('L') == moves.count('R') and moves.count('U') == moves.count('D'))