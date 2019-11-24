extends Node

class_name posture

export var transitions_from: PoolStringArray
export var transitions_animation: PoolStringArray
export var idle_anim: String

func _ready():
	var parent = get_parent()
	while !(parent is player):
		parent = parent.get_parent()
	parent.postures[name] = self

func get_transition_from(posture):
	var index = my_math.find(transitions_from, posture)
	if index != -1:
		return transitions_animation[index]
