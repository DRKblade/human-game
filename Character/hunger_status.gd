extends "res://Character/status.gd"

export var increment_to_parent = 0.2

func add(amount):
	.add(amount)
	if amount > 0:
		get_parent().add(amount*increment_to_parent)

func _status_process(delta):
	prints(name, "update")
	add(-delta)