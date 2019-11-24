extends "res://Character/basic_action.gd"

var structure

func action():
	if structure != null:
		while structure.modulate == Color.white:
			structure = null
			get_parent().pullout_slot.deplete_item()
