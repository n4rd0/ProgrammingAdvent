import copy

stack = {
    '1': ['D', 'L', 'V', 'T', 'M', 'H', 'F'],
    '2': ['H', 'Q', 'G', 'J', 'C', 'T', 'N', 'P'],
    '3': ['R', 'S', 'D', 'M', 'P', 'H'],
    '4': ['L', 'B', 'V', 'F'],
    '5': ['N', 'H', 'G', 'L', 'Q'],
    '6': ['W', 'B', 'D', 'G', 'R', 'M', 'P'],
    '7': ['G', 'M', 'N', 'R', 'C', 'H', 'L', 'Q'],
    '8': ['C', 'L', 'W'],
    '9': ['R', 'D', 'L', 'Q', 'J', 'Z', 'M', 'T']
}

stack2 = copy.deepcopy(stack)
fstar, scndstar = "", ""

f = open("ProgramingAdvent\AoC2022\D5\D5.txt", 'r')
instructions = f.read().replace("move","").replace("from","").replace("to","").split("\n")
instructions_final = []
for ins in instructions: instructions_final.append(ins.split())

#LOOP AMOUNT, #ORIGIN #DESTINY

for ins in instructions_final: 

    for i in range(int(ins[0])):
        package = stack[ins[1]].pop()
        stack[ins[2]].append(package)

for ins in instructions_final:
    package = stack2[ins[1]][-int(ins[0]):]
    for item in range(int(ins[0])): stack2[ins[1]].pop()
    stack2[ins[2]].extend(package)

for v in stack.values(): fstar += v[-1]
for v in stack2.values(): scndstar += v[-1]

print("\nfst star: ",fstar , "\nsecnd star: ", scndstar, "\n")