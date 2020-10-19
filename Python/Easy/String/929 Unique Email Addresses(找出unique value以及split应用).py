#我的办法是生成一个list，然后用pandas.unique来找出这个list里面独特值，然后计算个数
import pandas as pd
email = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
new_email = []
for i in email:
    local,domain = i.split('@')
    #print(local,domain)
    local = local.replace('.','').split('+')
    #print(local[0])
    email_new = local[0] + '@' + domain
    #print(email_new)
    new_email.append(email_new)
#print(new_email)
new_email = pd.unique(new_email).tolist()
#print(new_email)
print(len(new_email))




#可是如果我们不把生成的新邮箱地址放在list里面，而放在set里面，那么python就会自动生成unique value
email = ["test.email+alex@leetcode.com","test.e.mail+bob.cathy@leetcode.com","testemail+david@lee.tcode.com"]
new_email = set()
for i in email:
    local,domain = i.split('@')
    #print(local,domain)
    local = local.replace('.','').split('+')
    #print(local[0])
    email_new = local[0] + '@' + domain
    #print(email_new)
    new_email.add(email_new)   #但是注意，对于set而言，添加新的value是add而不是append了
#print(new_email)
print(len(new_email))