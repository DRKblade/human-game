extends structure

export var station_name:String

func _on_enter(player):
	player.speed.add_effect(Items.effects["bush_drag"])
	player.set_craft_station(station_name, true)

func _on_exit(player):
	player.speed.remove_effect("bush_drag")
	player.set_craft_station(station_name, false)
