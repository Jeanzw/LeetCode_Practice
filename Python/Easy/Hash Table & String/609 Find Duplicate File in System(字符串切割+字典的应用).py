#这一道题的意思就是说，我们要把相同content的文件路径给集合起来，同时对应的路径补全
class Solution:
    def findDuplicate(self, paths: List[str]) -> List[List[str]]:
        res = dict()
        for path in paths:  #此处相当于把所有的块给分了
            #print(path)
            items = path.split()  #将每一块的内部给分了
            #print(items)
            direct = items[0]   #确定路径的开头
            #print(direct)
            for i in range(1,len(items)): #因为我们并不需要第一个，因为第一个已经确认了是路径的开头了，在这一个for循环中，我们是要根据content将文件给分类了
                ind = items[i].find('(') #此处就是去找content的内容的
                file_name = items[i][:ind]  #这是文件名
                file_content = items[i][ind + 1:-1]
                if file_content not in res:  #此处我们相当于是将content当作key，而文件名当作value
                    res[file_content] = [direct + '/' +file_name]
                else:
                    res[file_content].append(direct + '/' +file_name)
            
        #到了这一步之前，我们相当于是已经按照content将文件路径分明别类的分好了
        #接下来我们来抽取文件了
        file = []
        for _,value in res.items():  #此处又一个tip就是当我们不需要用某个值但是这个值又需要体现的时候直接用下划线即可
            if len(value) > 1:
                file.append(value)
        return file


#别人写的比较简单的版本：
def findDuplicate(self, paths):
    M = collections.defaultdict(list)
    for line in paths:
        data = line.split()
        root = data[0]
        for file in data[1:]:
            name, _, content = file.partition('(')  #此处的partition相当于我们根据后面参数里面的符号进行切分，分为左中右三部分
            M[content[:-1]].append(root + '/' + name)
            
    return [x for x in M.values() if len(x) > 1]