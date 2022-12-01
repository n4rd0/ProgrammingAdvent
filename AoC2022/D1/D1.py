max = -1
temp = 0
with open("D1\D1.txt", 'r') as input:

    for l in input.readlines():

        if l != "\n":
            temp+=int(l)
        else: 
            if temp > max:
                max = temp 
            temp = 0 

print(max)

temp = 0 
max = -1
listCal =[]

with open("D1\D1.txt", 'r') as input:

    for l in input.readlines():

        if l != "\n":
            temp+=int(l)
        else: 
            listCal.append(int(temp))
            temp = 0 

listCal.sort()
listCal = listCal[::-1]
print(sum(listCal[:3]))

    
