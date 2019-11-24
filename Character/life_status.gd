extends "res://Character/regen_status.gd"

export var hit_multiplier = 1

func add_hit(value):
	.add(value*hit_multiplier)