extends item

class_name consumable

export var hunger: float
export var energy: float

func on_use(player):
	player.change_hunger(hunger)
	player.change_energy(energy)

func use_action():
	return "consume"

func on_busy(player):
	player.speed.add_effect(Items.effects["busy"])

func require_free():
	return false

func usable():
	return true