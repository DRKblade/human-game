extends "res://Character/basic_action.gd"

var drop_slot

func action():
	if !drop_slot.is_empty():
		if .action():
			yield()
		Items.drop_item(drop_slot.item, drop_slot, my_player.global_position, my_player.get_global_mouse_position() - my_player.global_position, drop_slot.qty)
		drop_slot.clear()
		my_player.anim.play("throw1" if get_parent().get_current_hand() else "throw2")
		yield()
	drop_slot = null

func anim_process():
	if drop_slot != null:
		return action()