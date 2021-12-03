file = open("D03Input.txt", "r")
lines = file.readlines()

cero_counter = 0
one_couner = 0
gamma_rate = ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']
epsilon_rate = ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']
list_ones = []
list_zeros = []
res = lines

for x in range(0, 12):
    for line in lines:
        if line[x].__eq__("0"):
            cero_counter += 1
        else:
            one_couner += 1
    if one_couner > cero_counter:
        gamma_rate[x] = '1'
    else:
        epsilon_rate[x] = '1'
    cero_counter = 0
    one_couner = 0

gamma_string = "".join(gamma_rate)
gamma_integer = int(gamma_string, 2)
epsilon_string = "".join(epsilon_rate)
epsilon_integer = int(epsilon_string, 2)
print("fst Star = ", epsilon_integer * gamma_integer)

for x in range(0, 12):
    for line in lines:
        if line[x].__eq__("0"):
            cero_counter += 1
            list_zeros.append(line)
        else:
            one_couner += 1
            list_ones.append(line)

    if one_couner >= cero_counter:
        for x in list_zeros:
            lines.remove(x)
    else:
        for x in list_ones:
            lines.remove(x)
    list_ones = []
    list_zeros = []
    cero_counter = 0
    one_couner = 0
    if len(lines) == 1:
        break

res = lines
file2 = open("D03Input.txt", "r")
lines = file2.readlines()

for x in range(0, 12):
    for line in lines:
        if line[x].__eq__("0"):
            cero_counter += 1
            list_zeros.append(line)
        else:
            one_couner += 1
            list_ones.append(line)

    if cero_counter > one_couner:
        for x in list_zeros:
            lines.remove(x)
    else:
        for x in list_ones:
            lines.remove(x)
    list_ones = []
    list_zeros = []
    cero_counter = 0
    one_couner = 0
    if len(lines) == 1:
        break

oxygen = "".join(res)
oxygen_res = int(oxygen, 2)
co2 = "".join(lines)
co2_res = int(co2, 2)

print("scnd star",co2_res*oxygen_res)
