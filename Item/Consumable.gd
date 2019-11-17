extends item

class_name consumable

export var hunger: float
export var energy: float

onready var effect = Effects.effects["busy"]

func on_use(player):
	player.speed.remove_effect(effect)
	player.change_hunger(hunger)
	player.change_energy(energy)

func use_action():
	return "consume"

func on_busy(player):
	player.speed.add_effect(effect)

func require_free():
	return false

func usable():
	return true