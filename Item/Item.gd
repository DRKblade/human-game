extends Node

class_name item

export var max_stack: int
export var texture: Texture

func use_action():
	return null

func require_free():
	return true

func on_busy(player):
	pass

func equipment():
	return null