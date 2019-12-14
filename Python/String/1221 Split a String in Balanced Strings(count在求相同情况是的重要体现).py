#这道题其实要知道原本s就是Balanced strings
#而我们要找的也是balanced strings，那么其实小的balanced strings加在一起一定就会组成原本的string了
#那么我们其实去计算L和R的个数就好了，一旦两者相等的时候就是balanced strings，那么就可以在balanced string的个数上加上1
#由于这里并没有要求一定是对称的，只是要求数量一样即可，所以只需要考虑数字个数就好
s = "LLLLRRRR"
class Solution:
    def balancedStringSplit(self, s: str) -> int:
        l_count = 0
        r_count = 0
        res = 0
        for i in s:
            if i == 'L':
                l_count += 1
            else:
                r_count += 1
            if l_count == r_count and l_count != 0:
                res += 1
        return res


#另外一种思路，其实也是计算个数的，如果是L那么我们就+1，如果是R那么就-1，当L和R个数相等时那么一定是0，那么我们就在balanced string上+1
res = cnt = 0         
for c in s:
    cnt += 1 if c == 'L' else -1            
    if cnt == 0:
        res += 1
print(res)  

