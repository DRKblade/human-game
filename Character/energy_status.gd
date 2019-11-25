extends "res://Character/regen_status.gd"

export var negative_to_parent = 1
export var reduction_to_child = 0.1
export var increment_to_accel = 0.2

var regen_rate = 0
var my_player

func set_player(p):
	my_player = p

func get_regen_rate():
	return regen_rate

func set_value(value):
	if value <= 0:
		get_parent().add(value/multiplier*negative_to_parent)
		my_player.damage_taker.ensure_play("pulse-energy")
		.set_value(0.0000001)
	else: .set_value(value)

func add(amount):
	.add(amount)
	if amount < 0:
		get_child(0).add(amount*reduction_to_child)
		regen_rate = 0
		if value < 0.25 and value > 0.0000001:
			my_player.damage_taker.ensure_play("pulse-energy-half")
	else: regen_rate += amount*increment_to_accel

func _status_process(delta):
	._status_process(delta)
	regen_rate += base_regen_rate * delta