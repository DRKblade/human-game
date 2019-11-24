extends "res://Character/basic_action.gd"

var item
var pullout_action
export var posture = "busy"

func action():
	if .action():
		yield()
	my_player.anim.play("consume")
	yield()
	item.on_finish_use(my_player)
	if pullout_action.deplete():
		yield()

func on_first_anim():
	pullout_action.hand_equip.set_texture(item.texture)
	if .action():
		yield()

func on_removed():
	pullout_action.hand_equip.clear()
	