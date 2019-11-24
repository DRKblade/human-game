extends "res://Character/basic_action.gd"

var item
var pullout_action
export var posture = "busy"
export var menu_name:String

func action():
	if .action():
		yield()

func on_first_anim():
	pullout_action.hand_equip.set_texture(item.texture)
	Items.main_player["craft_menu"].find_node(menu_name).visible = true
	if .action():
		yield()

func on_removed():
	pullout_action.hand_equip.clear()
	Items.main_player["craft_menu"].find_node(menu_name).visible = false