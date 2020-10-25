'''
 Definition for singly-linked list.
 class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.next = None
 l1 = {val: 2, next: {val:4, next:{val:3, next: None}}}

“”“
这里对于linked list其实就是两个参数，一个是val，一个是next
对于l1 = [2,4,3]来说
l1.val = 2
l1.next.val = 4
l1.next.next.val = 3
”“”


head = {val: -1, next: {val: 7, next:None}}
head = {val: 7, next: {val: 0, next:None}}
head = {val: 0, next:{val: 8, next:None}}
head ={val: 8, next:None}'''

class Solution(object):
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        prevHead = head = ListNode(-1)  #我这里相当于重新创造了一个ListNode{val: -1, next: None}
        carry = 0
        while l1 != None or l2 !=None or carry:
            val = carry
            if l1 != None:
                val += l1.val
                l1 = l1.next
            if l2 != None:
                val += l2.val
                l2 = l2.next
            head.next = ListNode(val%10) 
            carry = val/10
            #我们这里其实是做了一个数学计算，也就是说当abc + cba的时候，我们先c + a，然后判断其相加是否大于10，如果大于10，那么就进位1
            #而val%10相当于是求了一个余数，比如说c + a = 6，那么直接最后一位就是6，而如果是16，那么最后一位还是6， 但是在val/10这一步的时候确定进位为1
            head = head.next
        return prevHead.next
