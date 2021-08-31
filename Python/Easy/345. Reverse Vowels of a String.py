class Solution:
    def reverseVowels(self, s: str) -> str:
        start = 0
        end = len(s) - 1
        s = list(s)
        v = ['a','e','i','o','u','A','E','I','O','U']
        while start < end:
            if s[end] not in v:
                end -= 1
                continue  #这里的continue很关键，因为这个决定了如果我们走到了这个if里面，那么处理后直接进入下一个while循环
            # 如果不加continue，那么我们处理完这个if里面的内容后，会继续走到最后，对start以及end又进行处理才进入下一个while循环
            elif s[start] not in v:
                start += 1
                continue
            s[start],s[end] = s[end],s[start]
            start += 1
            end -= 1
        return ''.join(s)