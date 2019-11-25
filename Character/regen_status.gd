extends "res://Character/status.gd"

export var base_regen_rate: float = 1
export var deplete_rate: float = 1

func get_regen_rate():
	return base_regen_rate

func _status_process(delta):
	var regen = get_regen_rate()*delta
	var multiplier = 1
	for child in get_children():
		if child.has_method("get_healthiness"):
			multiplier *= child.get_healthiness()
	add(regen*multiplier if multiplier > 0 else -deplete_rate)
