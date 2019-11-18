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
	for i in array.size():
		if array[i] == item:
			return i
	return -1

func poisson(avg: float):
	var rnd = randf()
	if rnd == 1:
		return 0
	var result = 0
	var prob = exp(-avg)
	rnd -= prob
	while rnd > 0:
		result += 1
		prob *= avg/result
		rnd -= prob
	return result

func round_vector(value: Vector2, grid_size: Vector2):
	value.x = round(value.x / grid_size.x)*grid_size.x
	value.y = round(value.y / grid_size.y)*grid_size.y
	return value

func my_length(value:Vector2):
	return max(abs(value.x),abs(value.y))

func rand_direction():
	var angle = randf()*PI*2
	return Vector2(sin(angle), cos(angle))