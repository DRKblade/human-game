extends Node

func _process(delta):
	var mouse_pos = get_parent().get_global_mouse_position()
	get_parent().look_at(mouse_pos)
