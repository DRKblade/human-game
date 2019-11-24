extends Node

var my_posture
var my_player
export var priority = 0

func action():
	while my_player.posture != my_posture.name:
		my_player.anim.play(my_posture.get_transition_from(my_player.posture))
		return true
	return false

func _enter_tree():
	var parent = get_parent()
	while !(parent is player):
		if parent is posture:
			my_posture = parent
		parent = parent.get_parent()
	parent.add_action(self)
	my_player = parent
func _ready():
	if has_method("set_player"):
		call("set_player", my_player)