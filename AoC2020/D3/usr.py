def to_int(c):
    return 1 if c == "#" else 0

def parse(path):
    lines = None
    with open(path) as f:
        #We read the file and turn '#'->1, '.'->0
        lines = [[to_int(c) for c in line] for line in f.read().splitlines()]
    return lines

def s1(inp, direction=(3,1)):
    #Number of columns
    l = len(inp[0])
    s = 0
    # inp[::direction[1]] gives the elements in inp, but
    #jumping by d[1], a = [1,2,3,4], a[::2] = [1,3]
    # enumerate counts the number of times the loop is called
    for (i, line) in enumerate(inp[::direction[1]]):
        s += line[(i*direction[0]) % l]
    """
    #that loop is equivalent to
    for i in range(0, len(inp), direction[1]):
        line = inp[i]
        s += line[(i*direction[0]) % l]
    """
    return s

def s2(inp):
    dirs = [(1,1), (3,1),(5,1),(7,1),(1,2)]
    # [f(b) for b in l] is a foreach that generates a new list
    #where each element is f(b)
    #here, we generate a new list where each element is s1(inp,d)
    #foreach direction that we have
    trees = [s1(inp, direction) for direction in dirs]
    prod = 1
    # In python all loops are foreach, so
    #for p in trees
    #is more efficient and easier to read than
    #for i in range(len(trees))
    for p in trees:
        prod *= p
    return prod

if __name__ == '__main__':
    inp = parse("data.txt")
    print("Star 1:", s1(inp))
    print("Star 2:", s2(inp))
