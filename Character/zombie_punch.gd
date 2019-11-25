extends "res://Character/punch_action.gd"

var hittables = []
export var lookat_smoothing = 0.2
export var lookat_min_distance = 200
export var hit_active = false
var lookat_target = Vector2.ZERO
var lookat = Vector2.ZERO
	
func on_enter(body):
	if body != my_player:
		if body is player:
			hittables.push_front(body)
		elif body.has_method("on_hit"):
			hittables.push_back(body)

func on_exit(body):
	if (body.has_method("on_hit") or body is player) and body != my_player:
		hittables.remove(hittables.find(body))

func anim_process():
	if hittables.size() > 0:
		return action()

func _physics_process(delta):
	if hittables.size() > 0:
		lookat_target = hittables[0].global_position
	else:
		lookat_target = $movement/movement.direction * lookat_min_distance + my_player.global_position
	lookat += (lookat_target - lookat) * lookat_smoothing
	my_player.look_at(lookat)