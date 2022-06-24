def RmPunct(a):
    punctuations = '''!()-[]{};:'"\,<>./?@#$%^&*_~'''
    # 这里我们用''' '''就可以避免和里面的’以及”产生反应了
    for x in a:
        if x in punctuations:
            a = a.replace(x,'') #这道题其实就是在考replace，replace(a,b)将a换成b
    return a