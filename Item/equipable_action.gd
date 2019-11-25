extends "res://Character/basic_action.gd"

export var posture = "free"
var pullout_action
var equipment
var item

func get_hit_active():
	return pullout_action.hit_active

func action():
	if .action():
		yield()
	while true:
		if energy != null:
			if energy.value >= 0:
				energy.add(-equipment.use_energy)
			else: break
		my_player.anim.play("strike")
		equipment.start_hit()
		yield()
		equipment.end_hit()
		if !Input.is_action_pressed(input_action):
			break

func on_first_anim():
	pullout_action.hand_equip.set_child(equipment)
	equipment.on_attached("strike")
	if .action():
		yield()

func on_removed():
	pullout_action.hand_equip.clear()
