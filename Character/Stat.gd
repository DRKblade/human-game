class_name stat

var value = 0
var actual_value
var effects = Array()

func _init(value):
	self.value = value
	actual_value = value

func find_effect(name):
	for i in effects.size():
		if effects[i].name == name:
			return i
	return -1

func add_effect(effect_name):
	var effect = Items.effect(effect_name)
	if effect.stackable or find_effect(effect.name) == -1:
		effects.push_back(effect)
		calc_actual_value()

func remove_effect(name):
	var effect_id = find_effect(name)
	if effect_id != -1:
		effects.remove(effect_id)
	calc_actual_value()

func calc_actual_value():
	actual_value = value
	for effect in effects:
		actual_value *= effect.value

