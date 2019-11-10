extends item_source

var speed_effect = item_database.effects["bush_drag"]

func _on_enter(player):
	player.speed.add_effect(speed_effect)

func _on_exit(player):
	player.speed.remove_effect("bush_drag")