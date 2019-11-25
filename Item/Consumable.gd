extends equipable

class_name consumable

export var hunger_value: float
export var energy_value: float
export var rot_speed: float
export var use_action = "consume"

onready var effect = Effects.effects["busy"]

func on_finish_use(player):
	player.properties["hunger"].add(hunger_value)
	player.properties["energy"].add(energy_value)

func use_action():
	return "consume"

func require_free():
	return false

func item_process(delta, slot):
	slot.rot_state += rot_speed *delta
	return slot.rot_state >=1

func get_action(pull_out):
	var result = .get_action(pull_out)
	result.item = self
	return result

func combine(my_slot, other_slot, other_qty):
	my_slot.rot_state = (my_slot.rot_state*my_slot.qty + (other_slot.rot_state if other_slot != null else 0)*other_qty)/(my_slot.qty + other_qty)