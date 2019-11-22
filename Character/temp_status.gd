extends "res://Character/status.gd"

func _ready():
	if $heating == null:
		print("error: invalid child")

func _status_process(delta):
	add($heating.value*delta)