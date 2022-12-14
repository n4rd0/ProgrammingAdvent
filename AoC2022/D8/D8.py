f = open("D8.txt", 'r')
input  = []

for line in f.readlines():
    line = line.replace("\n", "")
    row = []

    for c in line:
        row.append(int(c))
    input.append(row)

#ROW COLUMN 0 - 98 square 99x99 

fstar = len(input)*4-4

for i in range(1,len(input)-1):
    for j in range(1,len(input[i])-1):
        print("left ", input[i][:j], "right ", input[i][j+1:])
        print("top ", input[:i], "bottom ", input[i:], "\n")



print("Fstar: ", fstar)

