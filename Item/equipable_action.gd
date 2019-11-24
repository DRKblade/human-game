extends "res://Character/basic_action.gd"

export var posture = "free"
var pullout_action
var equipment
var item

func action():
	if .action():
		yield()
	while true:
		my_player.anim.play("strike")
		equipment.start_hit()
		yield()
		equipment.end_hit()
		if !Input.is_action_pressed(input_action):
			break

func on_first_anim():
	pullout_action.hand_equip.add_child(equipment)
	equipment.on_attached("strike")
	if .action():
		yield()

func on_removed():
	pullout_action.hand_equip.remove_child(equipment)
