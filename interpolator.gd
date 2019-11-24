extends Node

export var interpolated_prop:String
export var smoothing = 0.1
var target_value:float = 0 setget set_target_value

func _process(delta):
	set(interpolated_prop, get(interpolated_prop) + (target_value - get(interpolated_prop))*smoothing)

func set_target_value(value):
	target_value = value
