extends Node

var effects = {}

func _enter_tree():
	for child in get_children():
		effects[child.name] = child
		remove_child(child)
