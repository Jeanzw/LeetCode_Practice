#我这里的思路是，把数字变成字符串然后就可以一个个抽出来数字，然后再转换为数字
n = 21
s = str(n)
l = len(s)
if n < 10:
    sum = n
while n >=10:
    sum = 0
    for i in str(n):
        sum += int(i)
    n = sum
print(n)

print(123/10)


#下面是张刚的思路，直接用求余和求整来判断
 while True:
    res = 0
    while num != 0:
        res += num%10
	    num /=10
    if res < 10:
	    return res
    num = res
