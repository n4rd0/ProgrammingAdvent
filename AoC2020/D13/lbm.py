from math import ceil

def getInput(path, part):
	with open(path) as f:
		if part == 1:
			soonest_departure = int(f.readline())
			bus_ids = [int(loop_time) for loop_time in f.readline().split(',') if loop_time != 'x']
			return soonest_departure, bus_ids
		else:
			f.readline()
			offset_and_loop_time = enumerate(f.readline().split(','))
			return [(int(offset), int(loop)) for offset, loop in offset_and_loop_time if loop != 'x']

def fastest_bus_id_and_arrival(soonest_departure, bus_ids):
	# The loop time of a bus is also its ID
	fastest_bus_id = bus_ids[0]
	fastest_arrival = get_arrival_time(soonest_departure, fastest_bus_id)

	for loop_time in bus_ids[1:]:
		arrival = get_arrival_time(soonest_departure, loop_time)

		if arrival < fastest_arrival:
			fastest_arrival = arrival
			fastest_bus_id = loop_time

	return fastest_bus_id, fastest_arrival

def get_arrival_time(soonest_departure, loop_time):
	return loop_time * ceil(soonest_departure / loop_time)

def earliest_timestamp(offset_and_loop_time):
	# Finds solution for a system of congruence equations, starts with biggest modulo
	remainder_and_modulo = get_remainder_and_modulo(offset_and_loop_time)

	accumulated_loop_time = remainder_and_modulo[0][1]
	t = remainder_and_modulo[0][0]

	for remainder, modulo in remainder_and_modulo[1:]:
		
		while t % modulo != remainder:
			t += accumulated_loop_time

		accumulated_loop_time *= modulo

	return t

def get_remainder_and_modulo(offset_and_loop_time):
	# e.g. loop_time * n = t + time_offset, for some n
	# i.e. t = loop_time * n - time_offset
	# i.e. t = - time_offset (mod loop_time)
	# i.e. t = remainder (mod modulo)
	# want 0 <= remainder <= modulo
	remainder_and_modulo = [((-offset) % modulo, modulo) for offset, modulo in offset_and_loop_time]
	return sorted(remainder_and_modulo, reverse = True, key = lambda x: x[0])


inputPath = "test13.txt"

soonest_departure, bus_ids = getInput(inputPath, 1)
fastest_bus_id, fastest_arrival = fastest_bus_id_and_arrival(soonest_departure, bus_ids)
print("Star 1:", fastest_bus_id * (fastest_arrival - soonest_departure))

offset_and_loop_time = getInput(inputPath, 2)
print("Star 2:", earliest_timestamp(offset_and_loop_time))