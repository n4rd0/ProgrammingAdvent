mapCharValue = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5, 'f': 6, 'g': 7, 'h': 8, 'i': 9, 'j': 10, 'k': 11, 'l': 12, 'm': 13, 'n': 14, 'o': 15, 'p': 16, 'q': 17, 'r': 18, 's': 19, 't': 20, 'u': 21, 'v': 22, 'w': 23, 'x': 24, 'y': 25, 'z': 26}
input = []
input2 = []

with open("ProgramingAdvent\AoC2022\D3\D3.txt", 'r') as f: 
    for l in f.readlines():
        l = l.replace("\n","")
        input.append([l[:int(len(l)/2)], l[int(len(l)/2):]])
        input2.append(l)

def calcValue(string):
    res = 0
    for char in string: 
        if char.isupper():
            char = char.lower()
            res += 26 
            res += mapCharValue[char]
        else:
            res += mapCharValue[char]
    return res

commonChars = ""
for l in input:
    for char in l[0]: 
        if char in l[1]:
            commonChars+=char
            break

fstStar = calcValue(commonChars)
        
threeGroup = []
for i in range(0,int(len(input2)),3): 
    threeGroup.append(input2[i:i+3])

commonChars = ""
for pack in threeGroup:
    for char in pack[0]:
        if char in pack[1] and char in pack[2]:
            commonChars += char
            break

scndStar = calcValue(commonChars)
print("frst star: ",fstStar, "snd star: ",scndStar)