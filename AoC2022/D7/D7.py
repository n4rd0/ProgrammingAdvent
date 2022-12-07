
input, currentKeydics, cwd_temp, cwd = [], [], [], []
dictDir = {}
fstar, scndstar = 0, 0
MAX_CAPACITY = 70_000_000
NEEDED_FREE_SPACE = 30_000_000

with open("D7.txt", 'r') as f: 
    for i in f.readlines(): input.append(i.replace("\n", ""))

for line in input:

    if line == "$ cd ..":
        
        poped = cwd.pop()
        keyDir = '_'.join(cwd)
        currentKeydics.pop()

    elif "$ cd" in line:

        cwd.append(line[5:])
        keyDir = '_'.join(cwd)
        if keyDir not in dictDir: dictDir[keyDir] = 0 
        currentKeydics.append(keyDir)
    
    if "dir " not in line and '$' not in line:
        for key in currentKeydics: dictDir[key] += int(line.split()[0])

needToFree = -MAX_CAPACITY+dictDir['/']+NEEDED_FREE_SPACE
scndstar = MAX_CAPACITY

for v in dictDir.values():

    if v < 100000:
        fstar +=v
    if scndstar > v > needToFree: scndstar = v

print("Fstar: ",fstar, "Scndstar: ", scndstar)
