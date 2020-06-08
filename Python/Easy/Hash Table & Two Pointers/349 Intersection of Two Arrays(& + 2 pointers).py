nums1 = [1,2,2,1]
nums2 = [2,2]

#我的想法就是保证nums是短的，然后将其变成set让它的元素都是唯一的，然后去扫nums2里面是否有nums1的内容
if len(nums1) > len(nums2):
    num = nums1
    nums1 = nums2
    nums2 = num
#print(nums1,nums2)  #这时候已经调换了nums1和nums2的顺序了
#python的string/list以及set的相互转换：https://blog.csdn.net/u014755493/article/details/69400292
nums1=set(nums1)
#print(nums1)
res = []
for i in nums1:
    #print(i)
    if i in nums2:
        res.append(i)
print(res)


#大神思路：
#直接将nums1和nums2变成set，然后求其交集
nums1 = [1,2,2,1]
nums2 = [2,2]
print(list(set(nums1) & set(nums2)))   #用&求交集
#求两列表的交集/并集/差集：https://blog.csdn.net/manjhOK/article/details/79584110
