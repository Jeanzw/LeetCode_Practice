chars = ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
count = 1
pos = 0
for i in range(len(chars)-1):
    #print(i)
    if i < len(chars) and chars[i] == chars[i + 1]:  #计算一样的个数
        count += 1
        #print(count)
    else:
        chars[pos] = chars[i]
        pos += 1
        if count > 1:
            for j in str(count):
                chars[pos] = j
                pos += 1
        count = 1

print(chars)




#思路2：问Gang
chars = ["a","a","b","b","c","c","c"]
anchor = write = 0
for read, c in enumerate(chars):
    if read + 1 == len(chars) or chars[read + 1] != c:
        chars[write] = chars[anchor]
        write += 1
        if read > anchor:
            for digit in str(read - anchor + 1):
                chars[write] = digit
                write += 1
        anchor = read + 1
#print(write)
        
        


#思路3：超直接
class Solution(object):
    def compress(self, s):
        """
        :type chars: List[str]
        :rtype: int
        """
        l,r = 0,0
        s.append("~~~")
        cur_letter,cur_count = None,0   #我们先初始化现在的字母和计数
        while r < len(s):   #r是一个index，我们这里是确定index在len(s)里面
            if cur_letter == None:  #我们在扫第一个字幕的时候，cur_letter还是初始化的样子，为0
                cur_letter = s[r]  #但是我们已经把这个时候扫到的第一个字母给了cur_letter
                cur_count = 1
                r += 1  # r + 1去扫下一个字母
            elif s[r] == cur_letter:  #如果下一个字母和我们上一个if扫出来的字母是一样的，就可以进行这一步
                cur_count += 1   #这里是计算重复的字母有多少个
                r += 1   #继续去扫下一个字母
            elif s[r] != cur_letter:  #如果下一个字母和我们上一个字母不一样，那么就进入这一步的操作
                if cur_count == 1:   #如果cur_count为1，然后字母已经开始改变了，那么其实就不用写count数量了，直接将这个字母放在某一个位置，然后这个位置开始跳下一个位置了
                    s[l] = cur_letter
                    cur_letter = s[r]  #然后我们把新的字母变为cur_letter然后再从这开始扫扫扫呀
                    cur_count = 1  #当然计数器又要变回为1了
                    l += 1  
                else:
                    s[l] = cur_letter
                    str_cur_count = str(cur_count)
                    for i in xrange(len(str(cur_count))):
                        s[l + i + 1] = str_cur_count[i]
                    cur_letter = s[r]
                    cur_count = 1
                    l += 1 + len(str_cur_count)
                r += 1
        return l




#思路4:gang的思路
class Solution:
    def compress(self, chars: List[str]) -> int:
        i = 0   #扫描过程前指针
        j = 0   #扫描过程后指针
        start = 0   #更改位置的指针
        
        while i < len(chars) and j <len(chars):  #这里保证了前后指针一定是在chars里面走的
            if j + 1 == len(chars) or chars[j+1] != chars[j]:#这里也就是说，我们排除了：如果j已经到了最后一位，或者说，j开始要扫新的字母的时候
                cnt = j - i + 1  #那么前一个字母的长度应该是j - i + 1
                chars[start] = chars[i]  #既然既非j扫到了最后一位，也不是j扫新的字母，那么这里i就是前指标，那么start就是要和前指标对其
                #比如说["a","a","b","b","c","c","c"]
                #我们在扫a的时候，i一直都是在0这个位置上，只要j不开始取扫b，那么我们在换数的时候，0这个位置上start也就是i的内容，然后start往右走一下，那么才到了开始加数字的阶段
                if cnt == 1:
                    start += 1  #如果只有单独的一个字母，那么不需要写数字了，直接就让start往后走一个
                else:
                    cntStr = str(cnt) #比如说如果是11，那么就要分为‘1’‘1’
                    for k in range(len(cntStr)):
                        chars[start + k + 1] = cntStr[k]  #比如说11，那么我们k首先扫第一个1，这个时候k为0，那么需要替换的位置是字母后的第一位，然后扫第二个1的时候，k为1，那么需要替换的位置是字母后的第二位
                    start += 1 + len(cntStr)  #同样数字算好之后，那么start就要跳到新的字母的第一位开始继续替换了
                i = j + 1
            j += 1
        return start
