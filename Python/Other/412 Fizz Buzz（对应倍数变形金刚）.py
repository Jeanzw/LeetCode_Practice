n = 15
list=[]
for i in range(1,n+1):
    #print(i)
    if i % 3 == 0 and i % 5 != 0:
        list.append('Fizz')
        continue
    if i % 3 != 0 and i % 5 == 0:
        list.append('Buzz')
        continue
    if i % 3 == 0 and i % 5 == 0:
        list.append('FizzBuzz')
        continue
    else:
        list.append(str(i))
print(list)        
        