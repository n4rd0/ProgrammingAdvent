

def firstStar(list_adapters):

	diff_counter_1 = 0
	diff_counter_3 = 1
	for index in range(len(list_adapters)-1):
		if list_adapters[index+1] - list_adapters[index] == 1:
			diff_counter_1 += 1
		elif list_adapters[index+1] - list_adapters[index] == 3:
			diff_counter_3 += 1

	return diff_counter_1 * diff_counter_3

def secondStar(list_adapters):
	possible_arrangements =[1]

	for index in range(1,len(list_adapters)):
		ways = len(list(i for i in range(list_adapters[index]-3,list_adapters[index]) if i in list_adapters))
		possible_arrangements.append(sum(possible_arrangements[index-ways:index]))

	return possible_arrangements[-1]
	

input_list = [0]
with open('input.txt') as file:
	input_list = input_list + sorted(map(int,file.read().splitlines()))

print(firstStar(input_list))
print(secondStar(input_list))