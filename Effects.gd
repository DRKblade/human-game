extends Node

var effects = {}

func _ready():
	for child in get_children():
		effects[child.name] = child
		remove_child(child)
