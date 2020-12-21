
def parse(path):
    lines = None
    with open(path) as f:
        lines = f.read().splitlines()
    return lines

def s1(inp, direction):
    l = len(inp[0])
    s = 0
    #inp[::] are slices
    for (i, line) in enumerate(inp[::direction[1]]):
        if line[(i*direction[0]) % l] == '#':
            s += 1
    return s

def s2(inp):
    dirs = [(1,1), (3,1),(5,1),(7,1),(1,2)]
    trees = [s1(inp, direction) for direction in dirs]
    prod = 1
    for p in trees:
        prod *= p
    return prod

if __name__ == '__main__':
    inp = parse("ndata.txt")
    print("Star 1:", s1(inp, (3,1)))
    print("Star 2:", s2(inp))
