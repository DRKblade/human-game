extends "res://Character/regen_status.gd"

export var negative_to_parent = 1
export var reduction_to_child = 0.1
export var increment_to_accel = 0.2

var regen_rate = 0

func get_regen_rate():
	return regen_rate

func add(amount):
	.add(amount)
	if amount < 0:
		get_child(0).add(amount*reduction_to_child)
		regen_rate = 0
		if value < 0:
			get_parent().add(value/multiplier)
	else: regen_rate += amount*increment_to_accel

func _status_update(delta):
	._status_update(delta)
	regen_rate += base_regen_rate * delta