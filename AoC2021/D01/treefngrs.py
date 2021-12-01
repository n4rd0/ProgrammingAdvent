xs = list(map(int, open("input.txt","r").read().splitlines()))
print(f"Star 1: {sum(x<y for (x,y) in zip(xs, xs[1:]))}")
print(f"Star 2: {sum(x<y for (x,y) in zip(xs, xs[3:]))}")