extends item_source

onready var effect = Effects.effects["structure_drag"]

func _on_enter(player):
	player.speed.add_effect(effect)

func _on_exit(player):
	player.speed.remove_effect(effect)