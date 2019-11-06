class_name Item

var max_stack
var texture
var name
var hunger
var energy

func _init(name, max_stack, texture = null, hunger = 0, energy = 0):
	self.name = name
	self.max_stack = max_stack
	self.texture = texture
	self.hunger = hunger
	self.energy = energy

func on_consume(player):
	player.change_hunger(hunger)
	player.change_energy(energy)