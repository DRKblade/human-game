extends "res://interpolator.gd"

export var text = "Name"
var rising = false
var state_machine

func _ready():
	var parent = get_parent()
	while !(parent is player):
		parent = parent.get_parent()
	prints(name, "connect")
	parent.properties[name].connect("value_changed", self, "set_target_value")
	
	$name.text = text
	state_machine = $anim.get("parameters/playback")
	state_machine.start("off")

func _mouse_entered():
	state_machine.travel("on")

func _mouse_exited():
	state_machine.travel("off")

func set_rising():
	rising = true

func unset_rising():
	rising = false