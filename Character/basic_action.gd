extends "res://Character/action.gd"

var queued = false
var energy

export var input_action: String

func set_player(my_player):
	energy = my_player.properties["energy"]

func unhandled_input(event):
	if Input.is_action_just_pressed(input_action):
		queued = true
		return true

func anim_process():
	if queued:
		queued = false
		return action()
