# A rock B paper C scissors
# X rock Y paper Z scissors
#win 6 loose 0  draw 3 

#Loose cases
# A 1 > Z 3 
# B 2 > X 1 
# C 3 > Y 2

#win cases
# A 1 < Y 2
# B 2 < Z 3
# C 3 < X 1


f = open("ProgramingAdvent\AoC2022\D2\D2.txt", 'r')

scheeme = []

for l in f.readlines(): 
    scheeme.append([l[0],l[2]])

mapPoints = {
    #points, name, draws, wins agaisnts, loose against
    'A': [1, "rock", 'X', 'Z', 'Y'], 
    'B': [2, "paper", 'Y', 'X', 'Z'],
    'C': [3, "scissors", 'Z', 'Y', 'X'],
    'X': [1, "rock"],
    'Y': [2, "paper"],
    'Z': [3, "scissors"]
}

def winner (oponentChoose, yourChoose) -> int:

    if mapPoints[oponentChoose][0] == mapPoints[yourChoose][0]:
        return 3
    elif oponentChoose == 'A':
        if yourChoose == 'Y':
            return 6 
    elif oponentChoose == 'B':
        if yourChoose == 'Z':
            return 6
    elif oponentChoose == 'C':
        if yourChoose == 'X':
            return 6
    return 0

def chooseAction(oponentChoose, result) -> str:
    if result == 'Y':
        return mapPoints[oponentChoose][2]
    if result == 'X':
        return mapPoints[oponentChoose][3]
    else:
        return mapPoints[oponentChoose][4]
    


def first_str():
    res = 0
    for l in scheeme: 
        res += winner(l[0], l[1]) + mapPoints[l[1]][0]
    return res 

def scnd_str():
    res = 0
    for l in scheeme: 
        print(l[0], l[1],chooseAction(l[0], l[1]))
        res += mapPoints[chooseAction(l[0], l[1])][0] + winner(l[0],chooseAction(l[0], l[1]))
    return res 

print(first_str())
print(scnd_str())

