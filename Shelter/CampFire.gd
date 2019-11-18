extends "res://CraftTable/CraftStation.gd"

func _enter_tree():
	inventory.get_slot(0).connect("start_consumption", self, "set_paused", [false])
	inventory.get_slot(0).connect("stop_consumption", self, "set_paused", [true])
	inventory.get_slot(0).consumption = $consumption
	set_paused(true)

func set_paused(value):
	$crafter.paused = value
	$burning.play("normal" if value else "burning")
