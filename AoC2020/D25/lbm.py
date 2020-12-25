MODULO = 20201227
SUBJECT_NUMBER = 7

def parse_input():
    with open("input25.txt") as f:
        return list(map(int, f.read().splitlines()))


def find_loop_size(public_key):
    value = 1
    loop_size = 0
    
    while value != public_key:
        value = (value * SUBJECT_NUMBER) % MODULO
        loop_size += 1
    
    return loop_size


def find_encryption(other_public_key, loop_size):
    encryption = other_public_key
    for _ in range(loop_size-1):
        encryption = (encryption * other_public_key) % MODULO
    
    return encryption


public_1, public_2 = parse_input()
loop_size_2 = find_loop_size(public_2)
encryption = find_encryption(public_1, loop_size_2)

print("Star 1:", encryption)
print("Star 2: not today")