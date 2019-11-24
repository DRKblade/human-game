extends Node

export var change_hand = 0.8
var current_hand = true

func get_current_hand():
	if get_parent().get("current_equip") != null:
		return false
	if randf() < change_hand:
		current_hand = !current_hand
	return current_hand 