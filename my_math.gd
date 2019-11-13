extends Node

func rand_abs(value_abs):
	return rand_range(-value_abs, value_abs)

func interpolate(a, b, t):
	return a + (b-a)*t

func rand_rounding(input:float):
	var rounded = int(input)
	var decimal = input - rounded
	return rounded if randf() > decimal else rounded + 1

func find(array, item):
	prints("find", item)
	for i in array.size():
		print(array[i])
		if array[i] == item:
			return i
	return -1