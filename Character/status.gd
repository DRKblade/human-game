extends "res://Character/character_property.gd"

signal value_changed

export var value: float = 1 setget set_value, get_value
export var multiplier = 0.05

func set_value(val):
	value = val
	emit_signal("value_changed", value)

func get_value():
	return value

func add(amount):
	self.value += amount*multiplier

func _ready():
	if has_method("_status_process"):
		Items.game.connect("status_process", self, "_status_process")
	emit_signal("value_changed", value)
	prints(name, value)

func get_healthiness():
	return value