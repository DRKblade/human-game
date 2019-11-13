extends item_source

func _on_enter(player):
	player.speed.add_effect(ItemDatabase.effects["bush_drag"])

func _on_exit(player):
	player.speed.remove_effect("bush_drag")