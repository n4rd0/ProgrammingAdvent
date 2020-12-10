import re
import collections

def bothStars(list_answers):
	diff_answer_sum = 0
	same_answer_sum = 0

	for answers in list_answers:

		all_answers = re.findall(r"[a-z]",answers)
		diff_answer_sum += len(set(all_answers))

		frecuencies = collections.Counter(all_answers)
		for nreps in frecuencies.values():
			if nreps == len(answers.split("\n")):
				same_answer_sum += 1

	return diff_answer_sum, same_answer_sum



with open('input.txt') as file:
	input_list = file.read().split("\n\n")

print(input_list)
print(bothStars(input_list))