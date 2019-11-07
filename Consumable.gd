extends item

class_name consumable

var hunger
var energy

func _init(name, max_stack, texture = null, hunger = 0, energy = 0).(name, max_stack, texture):
	self.hunger = hunger
	self.energy = energy

func on_consume(player):
	player.change_hunger(hunger)
	player.change_energy(energy)
