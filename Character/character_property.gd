extends Node

func _ready():
	var parent = get_parent()
	while !(parent is player):
		parent = parent.get_parent()
	parent.properties[name] = self
	if has_method("set_player"):
		call("set_player", parent)
