extends "res://Character/action.gd"

export var hand_equip_path: NodePath
export var hit_active: bool

onready var hand_equip = get_node(hand_equip_path)
var current_equip
var pullout_slot
var put_back = false
var custom_action

func action():
	if .action():
		yield()
	if current_equip != null and current_equip.item.has_method("get_action"):
		custom_action = current_equip.item.get_action(self)
		my_player.postures[custom_action.posture].add_child(custom_action)
		return custom_action.on_first_anim()

func put_back_action():
	if .action():
		yield()
	remove()

func remove():
	if custom_action != null:
		custom_action.on_removed()
		my_player.remove_action(custom_action)
		custom_action.get_parent().remove_child(custom_action)
		custom_action = null
		current_equip = null

func deplete():
	current_equip.deplete_item()
	if current_equip.is_empty():
		remove()
		return .action()

func anim_process():
	if pullout_slot != null:
		if custom_action == null:
			current_equip = pullout_slot
			pullout_slot = null
			return action()
		else: put_back = true
	if put_back:
		put_back = false
		return put_back_action()