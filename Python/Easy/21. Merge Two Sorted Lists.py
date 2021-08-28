# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        head = ListNode(0)  #这个的意思就是建立一个开头为0的ListNode，其实这个开头是什么不重要，只是在说我们要有一个开始
        start = head #我们这个让start和head产生一个联系
        # 这个产生联系的原理是：
        # 比如说
        # a = [1,2,3]
        # b = a
        # b[0] = 100 #这里相当于我们直接对b进行了修改
        # 那么打印出来的：b = [100,2,3]
        # 但是因为a和b之间已经有了一个联系，所以a = [100,2,3]

        # 但是这个联系如果是：
        # a = [1,2,3]
        # b = a
        # b = [3,2,1]  #这里相当于给b重新赋值了
        # 那么打印出来的b = [3,2,1]，而a是原来的样子a = [1,2,3]

        # 举上面两个例子是为了说明我们这里的情况其实就相当于第二种情况，我们对start进行处理，利用最开始的start = head产生初步联系
        # 而后我们start会一步步往后移动，但是我们仍旧用head保留最初的位置
        if l1 is None:
            return l2
        elif l2 is None:
            return l1
        while l1 and l2:
            if l1.val <= l2.val:  #这里我们判断l1和l2当前节点的大小情况
                start.next = l1  #我们在这里之所以用L1而不是l1.val是因为，对于linked list来说，是没有单独val存在的，都是属于链表的形式，我们这里要了L1就要了它之后的全部内容，只不过我们之后可以进行修改
                l1 = l1.next
            else:
                start.next = l2
                l2 = l2.next
            start = start.next #在这里我们相当于，做了一次比较，我们已经换了这个节点的数，然后我们移动start的位置，使其变成下一个节点，然后去改变下一个节点的数
        # 最后的两个判断是基于l1和l2可能不一样长，那么当短的跑完后，我们直接将长的链表后面部分直接衔接上来即可
        if l1 is None: 
            start.next = l2
        else:
            start.next = l1
        return head.next