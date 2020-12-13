
def firstStar(list_orders):
	repeated = False
	index = 0
	acc = 0
	executed_orders = []

	while not repeated and index < len(list_orders):
		if not index in executed_orders:
			executed_orders.append(index)
			if list_orders[index][0] == "acc":
				acc += int(list_orders[index][1])
				index += 1
			elif list_orders[index][0] == "jmp" and int(list_orders[index][1]) != 0:
				index += int(list_orders[index][1])
			else:
				index += 1

		else:
			repeated = True

	return acc,repeated,executed_orders


def secondStar(list_orders,executed_orders, possible_errors):
	for index_order in executed_orders:
		actual_order = list_orders[index_order][0]

		if actual_order in possible_errors:
			list_orders[index_order][0] = possible_errors[actual_order]
			result = firstStar(list_orders)
			list_orders[index_order][0] = actual_order
			if not result[1]:
				return result[0]


with open('input.txt') as file:
	input_list = file.read().splitlines()

input_list_2 = []
for orden in input_list:
	input_list_2.append(orden.split())

possible_errors ={ "jmp" : "nop",
				   "nop" : "jmp"}

result = firstStar(input_list_2)
print(result[0])
print(secondStar(input_list_2,result[2],possible_errors))