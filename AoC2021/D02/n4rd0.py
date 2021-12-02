import re
file = open("D02Input.txt","r")
lines = file.readlines()
file.close()
horizontal_depth_aim = [0 for i in range(3)]

for line in lines:
    number = 0
    n_moves = re.search(r'\d', line)
    if line[0].__eq__("f"):
        horizontal_depth_aim[0] += int(n_moves.group(0))
        horizontal_depth_aim[1] += horizontal_depth_aim[2]*int(n_moves.group(0))
    elif line[0].__eq__("d"):
        ##Only for fst Star
        ##horizontal_depth_aim[1] += int(n_moves.group(0))
        horizontal_depth_aim[2] += int(n_moves.group(0))
    else:
        ##Only for fst Star
        ##horizontal_depth_aim[1] -= int(n_moves.group(0))
        horizontal_depth_aim[2] -= int(n_moves.group(0))
    print("horiz", horizontal_depth_aim[0])
    print("depth", horizontal_depth_aim[1])
    print("aim", horizontal_depth_aim[2])

print(horizontal_depth_aim[0],horizontal_depth_aim[1],horizontal_depth_aim[0]*horizontal_depth_aim[1])
