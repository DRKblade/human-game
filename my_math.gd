extends Node

func rand_abs(value_abs):
	return rand_range(-value_abs, value_abs)

func interpolate(a, b, t):
	return a + (b-a)*t