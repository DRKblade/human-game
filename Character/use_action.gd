extends "res://Character/basic_action.gd"

var equip_tool

func action():
	if .action():
		yield()
	var use_action = equip_tool.use_action
	if equip_tool.use_action != null: 
		if equip_tool.use_energy != null:
			if energy.value >= equip_tool.use_energy:
				energy.add(-equip_tool.use_energy)
				equip_tool._start_hit()
			else: return
		my_player.anim.play(equip_tool.use_action)
		yield()
		if equip_tool.has_method("on_finish_use"):
			equip_tool.on_finish_use(player)
			get_parent().deplete_item()