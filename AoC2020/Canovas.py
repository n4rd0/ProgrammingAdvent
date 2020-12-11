import re

def firstStar(list_rules,set_valid_bags):
	temp_valid_bags = set()
	for rule in list_rules:
		for bag in set_valid_bags:
			if bag in rule.split("bags contain")[1]:
				temp_valid_bags.add(rule.split("bags contain")[0])

	new_set_valid_bags = set_valid_bags | temp_valid_bags
	new_length = len(new_set_valid_bags)

	return new_length-1 if new_length == len(set_valid_bags) else firstStar(list_rules,new_set_valid_bags) 


def secondStar(list_rules,yourBag):
	line = list(filter(lambda x: x.startswith(yourBag),list_rules))[0]
	numbers = re.findall(r"\d+",line)
	total_bags = sum(int(i) for i in numbers)

	for i in range(len(numbers)):
		element = re.findall(r"\D.*\s.*(?=bag|bags)",line.split("bags contain")[1].split(",")[i].strip())[0].strip()
		total_bags += int(numbers[i]) * secondStar(list_rules,element)

	return total_bags


with open('input.txt') as file:
	input_list = file.readlines()


print(firstStar(input_list,{"shiny gold"}))
print(secondStar(input_list,"shiny gold"))