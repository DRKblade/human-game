extends "res://Character/regen_status.gd"

export var hit_multiplier = 1
var my_player

func set_player(p):
	my_player = p

func add_hit(value):
	.add(value*hit_multiplier)

func add(amount):
	.add(amount)
	if amount > 0.1 and value < 1:
		my_player.damage_taker.ensure_play("pulsate-life")