extends "res://Character/status.gd"

export var base_regen_rate: float = 1

func get_regen_rate():
	return base_regen_rate

func _status_process(delta):
	var regen = get_regen_rate()*delta
	for child in get_children():
		if child.has_method("get_healthiness"):
			regen *= child.get_healthiness()
	add(regen if regen != 0 else -1)
