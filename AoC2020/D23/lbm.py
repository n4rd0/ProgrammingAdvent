def star_1(inp, highest, iterations):
	linked_list = execute(inp, highest, iterations)
	num = linked_list[1]
	res = ""
	while num != 1:
		res += str(num)
		num = linked_list[num]
		
	return res


def star_2(inp, highest, iterations):
	linked_list = execute(inp, highest, iterations)
	one = linked_list[1]
	return one * linked_list[one]


def substract(num, highest):
	return num-1 if num != 1 else highest


def execute(inp, highest, iterations):
	linked_list = dict(zip(inp, inp[1:]))
	if highest == 9:
		linked_list[inp[-1]] = inp[0]
	else:
		linked_list[inp[-1]] = 10

		for i in range(10, highest):
			linked_list[i] = i+1

		linked_list[highest] = inp[0]
	
	last = inp[0]
	for _ in range(iterations):
		one = linked_list[last]
		two = linked_list[one]
		three = linked_list[two]
		four = linked_list[three]
		next_three = [one, two, three]

		linked_list[last] = linked_list[three]

		last = substract(last, highest)
		while last in next_three:
			last = substract(last, highest)

		linked_list[three] = linked_list[last]
		linked_list[last] = one

		last = four	

	return linked_list


inp = [9, 5, 2, 3, 1, 6, 4, 8, 7]
print("Star 1:", star_1(inp, 9, 100))
print("Star 2:", star_2(inp, int(1E6), int(1E7)))