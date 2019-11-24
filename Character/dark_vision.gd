extends "res://interpolator.gd"

func _on_heating_value_changed(value):
	target_value = float(-value if value < 0 else 0)
