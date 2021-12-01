file = open("D01Input.txt", "r")
lines = file.readlines()
file.close()
lines = [int(numeric_string) for numeric_string in lines]
fstar = 0
scndstar = 0
for x in range(0, len(lines)-1):
    if lines[x] < lines[x+1]:
        fstar += 1

for x in range(0, len(lines) - 1):
    if sum(lines[x:x+3]) < sum(lines[x+1:x+4]):
        scndstar += 1
print(fstar)
print(scndstar)