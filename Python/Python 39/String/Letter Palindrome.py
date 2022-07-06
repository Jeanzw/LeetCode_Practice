def LettPalind(a):
    letter ='abcdefghigklmnopqrstuvwxyzABCDEFGHIGKLMNOPQRSTUVWXYZ'
    clean = ''
    for i in a:
        if i in letter:
            clean = clean + i  #string的加入就不需要append了，直接用+即可
    clean = clean.lower()
    return clean == clean[::-1]
