
f = open("ProgramingAdvent\AoC2022\D4\D4.txt", 'r')
input = []
for l in f.readlines(): input.append(l.replace("-", " ").replace(",", " ").replace("\n","").split())

fststar, secondstar = 0, 0 

for pair in input:
    if int(pair[0]) <= int(pair[2]) and int(pair[1]) >= int(pair[3]) or int(pair[0]) >= int(pair[2]) and int(pair[1]) <= int(pair[3]):
        fststar += 1
        
for pair in input: 

    leftPair, rightPair = [], []
    for i in range(int(pair[0]), int(pair[1])): leftPair.append(i)
    leftPair.append(int(pair[1]))
    for i in range(int(pair[2]), int(pair[3])): rightPair.append(i)
    rightPair.append(int(pair[3]))

    if list(set(rightPair).intersection(leftPair)) != []:
        secondstar += 1

print("fstar: ",fststar, "secondstar: ", secondstar)
