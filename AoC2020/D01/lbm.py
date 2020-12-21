with open("input1.txt") as f:
	inp = list(map(int, f.read().splitlines()))

print("Star 1:", [num*(2020-num) for num in inp if num!=1010 and 2020-num in inp][0])
print("Star 2:", [n1*n2*(2020-n1-n2) for n1 in inp for n2 in inp if n1!=n2 and n1!=(2020-n1-n2) and 2020-n1-n2 in inp][0])
