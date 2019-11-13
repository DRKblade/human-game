extends Node2D

var player

export var tool_class: PoolStringArray
export var hit_strength: int
var hit = Array()
var inactive = Array()
var animation_length

func _on_entered(area):
	hit.push_back(area)

func _on_exited(area):
	var index = hit.find(area)
	if index != -1:
		hit.remove(index)

func _hit_process():
	if player.hit_active:
		for body in hit:
			if body.has_method("on_hit") and inactive.find(body) == -1:
				my_math.find(tool_class, "nothing")
				body.on_hit(self, tool_class, hit_strength)
				inactive.push_back(body)
				break

func _start_hit():
	inactive.clear()