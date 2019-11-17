class_name stat

var value = 0
var actual_value:float
var effects = {"multiply":Array(), "pre_add":Array(), "post_add":Array()}

func _init(value):
	self.value = value
	actual_value = value

func add_effect(effect):
	var effect_arr = effects[effect.type]
	if effect.stackable or effect_arr.find(effect) == -1:
		effect_arr.push_back(effect)
		calc_actual_value()

func remove_effect(effect):
	var effect_arr = effects[effect.type]
	var effect_id = effect_arr.find(effect)
	if effect_id != -1:
		effect_arr.remove(effect_id)
		calc_actual_value()

func calc_actual_value():
	actual_value = value
	for effect in effects["pre_add"]:
		actual_value += effect.value
	for effect in effects["multiply"]:
		actual_value *= effect.value
	for effect in effects["post_add"]:
		actual_value += effect.value

