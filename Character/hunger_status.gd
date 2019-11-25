extends "res://Character/status.gd"

var my_player

func set_player(p):
	my_player = p
func _status_process(delta):
	add(-delta)

func add(amount):
	.add(amount)
	if amount < 0:
		if value < 0.25:
			my_player.damage_taker.ensure_play("pulse-hunger-half" if value > 0.0000001 else "pulse-hunger")