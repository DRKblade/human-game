extends "res://Character/action.gd"

func action():
	if .action():
		yield()
	my_player.anim.play("move")
	yield()

func anim_process():
	if $movement.direction != Vector2.ZERO:
		return action()
