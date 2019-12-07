class Solution:
    def toGoatLatin(self, S: str) -> str:
        vowel = ['a','e','i','o','u','A','E','I','O','U']
        S = S.split()
        print(S)
        for i in range(len(S)):
            #print(i)
            if S[i][0] in vowel:
                #print(True)
                S[i] = S[i] + 'ma' + 'a'* (i + 1)
            else:
                S[i] = S[i][1:] + S[i][0] +'ma' + 'a'* (i + 1)
        #print(S)
        S = ' '.join(S)  #这里的join其实就是指，将这些字符以空格的形式拼接起来
        return S