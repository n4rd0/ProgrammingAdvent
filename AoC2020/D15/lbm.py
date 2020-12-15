def play_game(starting_numbers, nth_spoken_number):
	previously_spoken = {num : i for i, num in enumerate(starting_numbers)}

	last_spoken_num = 0

	for i in range(len(starting_numbers) + 1, nth_spoken_number):
		last_time = previously_spoken.get(last_spoken_num, i - 1)
		previously_spoken[last_spoken_num] = i - 1
		last_spoken_num = i - 1 - last_time

	return last_spoken_num


starting_numbers = [1,12,0,20,8,16]

print("Star 1:", play_game(starting_numbers, 2020))
print("Star 2:", play_game(starting_numbers, 3*10**7))