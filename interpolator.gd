extends Node

export var interpolated_prop:String
export var smoothing = 0.1
var target_value:float = 0

func _process(delta):
	set(interpolated_prop, get(interpolated_prop) + (target_value - get(interpolated_prop))*smoothing)
