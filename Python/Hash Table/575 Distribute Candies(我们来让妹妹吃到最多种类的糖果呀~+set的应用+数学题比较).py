candies = [1,1,2,3]
n_candies = len(candies)        # number of candies
n_kinds = len(set(candies))     # number of kinds

if n_kinds > n_candies / 2:     # if there's more kinds than half of all candies
        print(int(n_candies / 2))       # sister will get always half of candies of different kind
else:       # if there's less kinds
        print(n_kinds)      # she will get all candies with different kinds
        
        
        

#另一种思路：
#我们假设说这里有n种不同的糖果len(set(candies))，然后妹妹也只能拿走其中的一半而已len(candies) / 2
#我们打个比方，如果这里有5种不同的糖果，如果妹妹要拿走4个，那么4种糖果都可以不同
        #但是如果这个时候，妹妹其实要拿走的糖果数量是7个呢？那么必定是有重复的，但是糖果种类最多也只能是5种
print(min(len(candies) / 2, len(set(candies))))

