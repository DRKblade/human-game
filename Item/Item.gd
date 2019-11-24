extends Node

class_name item

export var max_stack: int
export var texture: Texture
export var base_items:PoolStringArray
export var base_qtys:PoolIntArray
export var base_duration:float

func use_action():
	return null

func posture():
	return "free"

func on_busy(player):
	pass

func equipment(player):
	return null