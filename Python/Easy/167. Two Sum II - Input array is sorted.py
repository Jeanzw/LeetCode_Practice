class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        d = {} 
        # 字典可以说是查找最快的工具了
        for i in range(len(numbers)):
            if numbers[i] in d: 
                #我们在这里判断一下对应的数是否在字典里，这里d对应的是dictionary里面的key
                # 如果在就说明之前我们已经找到了与之配对的部分了
                return [d[numbers[i]] + 1, i + 1]
            d[target-numbers[i]] = i
            # 但是如果不在字典里，那么我们就往字典里面添加对应的数，但是注意我们这里只添加对应的index
        return [-1, -1]


# 另外一种思路就比较符合two pointer的思维了
# 使用双指针，一个指针指向值较小的元素，一个指针指向值较大的元素。指向较小元素的指针从头向尾遍历，指向较大元素的指针从尾向头遍历。
# 如果两个指针指向元素的和 sum == target，那么得到要求的结果；
# 如果 sum > target，移动较大的元素，使 sum 变小一些；
# 如果 sum < target，移动较小的元素，使 sum 变大一些。
# 数组中的元素最多遍历一次，时间复杂度为 O(N)。只使用了两个额外变量，空间复杂度为 O(1)。

class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        start = 0
        end = len(numbers) - 1
        while start < end:
            if numbers[start] + numbers[end] == target:
                return start + 1, end + 1
            elif numbers[start] + numbers[end] > target:
                end -= 1
            else:
                start += 1