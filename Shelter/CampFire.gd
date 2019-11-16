extends "res://CraftTable/CraftStation.gd"

func _ready():
	print("fire ready")
	print(inventory.get_slot(0).connect("start_consumption", self, "set_paused", [false]))
	print(inventory.get_slot(0).connect("stop_consumption", self, "set_paused", [true]))
	inventory.get_slot(0).consumption = $consumption
	set_paused(true)

func set_paused(value):
	$crafter.paused = value
	$burning.play("normal" if value else "burning")