extends item

class_name consumable

export var hunger: float
export var energy: float
export var rot_speed: float
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

func item_process(delta, slot):
	slot.rot_state += rot_speed *delta
	return slot.rot_state >=1

func combine(my_slot, other_slot, other_qty):
	my_slot.rot_state = (my_slot.rot_state*my_slot.qty + (other_slot.rot_state if other_slot != null else 0)*other_qty)/(my_slot.qty + other_qty)