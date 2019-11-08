extends item_source

export var wobble_distance = 10
export var wobble_duration = 0.5
var wobble_time = 0
var wobble_target = Vector2.ZERO
var speed_effect = item_database.effects["bush_drag"]
var wobbling
var wobble_animation: Animation

func _ready():
	wobble_animation = $anim.get_animation("wobble")

func _body_entered(body):
	if body is player:
		body.speed.add_effect(speed_effect)
		wobbling = true
		$anim.play("wobble")

func _body_exited(body):
	if body is player:
		body.speed.remove_effect("bush_drag")
		wobbling = false

func check_direction():
	if !wobbling:
		$anim.stop()
	var wobble = item_database.player.direction * wobble_distance
	wobble_animation.track_set_key_value(0,1,wobble)
	wobble_animation.track_set_key_value(0,3,wobble)