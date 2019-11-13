extends "res://MyTextureButton.gd"

func _on_toggled(button_pressed):
	$pop.visible = button_pressed
