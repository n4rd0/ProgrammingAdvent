import re
from operator import add, mul

import time

char_to_op = {'+' : add, '*' : mul}


def parse_input():
	with open("input18.txt") as f:
		inp = f.read().splitlines()

	inp = [re.findall(r"\d|\+|\*|\(|\)", expr) for expr in inp]
	return [[int(c) if c not in ['(', ')', '+', '*'] else c for c in expr] for expr in inp]


def star_1(inp):
	return sum(compute(expr, 0, add) for expr in inp)


def compute(ops, acc, last_op):
	if not ops:
		return acc

	if ops[0] == '(':
		parenthesis_acc, ops = compute(ops[1:], 0, add)
		acc = last_op(acc, parenthesis_acc)
		if not ops:
			return acc

	if ops[0] == ')':
		return acc, ops[1:]

	if ops[0] in ['+', '*']:
		return compute(ops[1:], acc, char_to_op[ops[0]])
	else:
		return compute(ops[1:], last_op(acc, ops[0]), last_op)


def star_2(inp):
	global current_expr
	exprs_sum = 0

	for expr in inp:
		current_expr = expr[:]
		exprs_sum += A()

	return exprs_sum


"""
Recursive descent parser grammar:

A  -> B B'
B' -> * A | lambda
B  -> C C'
C' -> + B | lambda
C  -> ( A ) | num

where num in 0-9 and X' is written as XX
"""

def A():
	return B() * BB()

def BB():
	if current_expr and current_expr[0] == '*':
		read_next()
		return A()
	else:
		return 1

def B():
	return C() + CC()

def CC():
	if current_expr and current_expr[0] == '+':
		read_next()
		return B()
	else:
		return 0

def C():
	if current_expr[0] == '(':
		read_next()
		acc = A()
		read_next()
		return acc
	else:
		num = current_expr[0]
		read_next()
		return num 


def read_next():
	global current_expr
	current_expr = current_expr[1:]

start = time.time()
inp = parse_input()

print("Star 1:", star_1(inp))
print("Star 2:", star_2(inp))
end = time.time()

print(end-start)