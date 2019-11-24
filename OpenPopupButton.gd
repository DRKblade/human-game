extends "res://MyTextureButton.gd"

var toggle_reversed = false

func _on_pressed():
	get_parent().child_pressed(self)

func set_expanded(value):
	$pop.visible = value
