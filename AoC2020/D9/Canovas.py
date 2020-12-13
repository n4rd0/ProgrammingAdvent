
def firstStar(list_numbers,preamble):
	interval = [0,preamble-1]

	for number in list_numbers[preamble:]:
		valid = False

		for index_previous in range(interval[0],interval[1]):
			diff = number - list_numbers[index_previous]
			if diff in  list_numbers[index_previous:interval[1]+1]:
				valid = True
				interval = [i+1 for i in interval]
				break

		if  not valid:
			return number

def secondStar(list_numbers,invalid_number):

	for index_number in range(len(list_numbers)-1):
		set_numbers = [list_numbers[index_number]]
		for i in list_numbers[index_number+1:]:
			set_numbers.append(i)
			if sum(set_numbers) > invalid_number:
				break

			elif sum(set_numbers) == invalid_number:
				return max(set_numbers) +  min(set_numbers)



with open('input.txt') as file:
	input_list = list(map(int,file.readlines()))

print(firstStar(input_list,25))
print(secondStar(input_list,1038347917))