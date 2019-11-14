extends Node2D

class_name structure

export var wobble_distance = 8
export var pushback_distance = 15
export var anim_wobble_value = 0.0
export var anim_pushback_value = 0.0

var wobbling = false
var wobble_player
var wobble_target = Vector2.ZERO
var pushback_target = Vector2.ZERO

func on_hit(source, tool_class, hit_strength):
	if has_method("_on_hit"):
		call("_on_hit", source, tool_class, hit_strength)
		$pushback.play("pushback")
		pushback_target = (global_position - source.global_position).normalized() * pushback_distance

func on_enter(body):
	if body is player and has_method("_on_enter"):
		call("_on_enter", body)
		wobbling = true
		wobble_player = body
		check_direction()

func on_exit(body):
	if body is player:
		if has_method("_on_exit"):
			call("_on_exit", body)
		wobbling = false

func _process(delta):
	$spr.position = anim_pushback_value * pushback_target + anim_wobble_value * wobble_target

func check_direction():
	if wobbling:
		$wobble.play("wobble")
		wobble_target = wobble_player.direction * wobble_distance
