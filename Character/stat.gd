extends "res://Character/character_property.gd"

class_name stat

signal value_changed

export var base_value = 0
onready var value:float = base_value
var effects = {"multiply":Array(), "pre_add":Array(), "post_add":Array()}

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
	value = base_value
	for effect in effects["pre_add"]:
		value += effect.value
	for effect in effects["multiply"]:
		value *= effect.value
	for effect in effects["post_add"]:
		value += effect.value
	emit_signal("value_changed", value)

