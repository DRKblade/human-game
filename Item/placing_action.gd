extends "res://Character/basic_action.gd"

var item
var pullout_action
var structure
export var put_structure_distance = 300
export var posture = "busy"

func action():
	if .action():
		yield()
	if structure.modulate == Color.white:
		pullout_action.hand_equip.texture = null
		structure = null
		pullout_action.put_back = true

func on_first_anim():
	pullout_action.hand_equip.texture = item.texture
	structure = item.get_structure()
	structure.modulate = Color.black
	Items.game.add_child(structure)
	if .action():
		yield()

func on_removed():
	pullout_action.hand_equip.texture = null

func _process(delta):
	if structure != null:
		var mouse_pos = my_player.get_global_mouse_position()
		if Input.is_action_just_pressed("game_rotate"):
			structure.rotation_degrees += 90
		structure.global_position = my_math.round_vector(mouse_pos, Vector2(80,80))
		structure.modulate = Color.white if my_math.my_length(structure.global_position - my_player.global_position) < put_structure_distance else Color(0.5,0.5,0.5,0.5)