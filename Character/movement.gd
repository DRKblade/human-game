extends stat

var energy
var direction = Vector2.ZERO
var speedup_energy = 0.1
var speedup_multiplier = 1.5
var last_speedup = false

func set_player(value):
	energy = value.properties["energy"]

func _physics_process(delta):
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var current_speed = value
	if Input.is_action_pressed("game_speedup") and direction != Vector2.ZERO:
		if energy == null:
			pass
		elif energy.value >= 0 or last_speedup:
			energy.add(-speedup_energy*delta)
		else: return
		current_speed *= speedup_multiplier
		last_speedup = energy.value != 0
		$speedup_trail.emitting = true
	else:
		$speedup_trail.emitting = false
	get_parent().move_and_slide(direction * current_speed)
