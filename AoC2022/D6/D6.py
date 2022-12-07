import collections

input =  open("D6.txt", 'r').readlines()[0]

def findDifChars(str, n):
    res = 0
    for i in range(len(str)):

        subString = str[i:i+n]
        dicTemp = collections.defaultdict(int)
        for char in subString: dicTemp[char] += 1 
        if len(dicTemp.keys()) == n: return res 
        res += 1

print("Fstar: ",4+findDifChars(input,4), "Secstar: ", 14+findDifChars(input,14))
