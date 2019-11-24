extends stat

var energy
var direction: Vector2
var speedup_energy = 0.1
var speedup_multiplier = 1.5
var last_speedup = false
var my_player

export var speedup_trail_path: NodePath
var speedup_trail

func _ready():
	speedup_trail = get_node(speedup_trail_path)

func set_player(value):
	my_player = value
	energy = value.properties["energy"]

func get_direction():
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

func is_speedup():
	return Input.is_action_pressed("game_speedup")

func _physics_process(delta):
	get_direction()
	var current_speed = value
	if is_speedup() and direction != Vector2.ZERO:
		if energy == null:
			pass
		elif energy.value >= 0 or last_speedup:
			energy.add(-speedup_energy*delta)
		else: return
		current_speed *= speedup_multiplier
		last_speedup = energy.value != 0
		if speedup_trail.get("emitting") != null:
			speedup_trail.emitting = true
	else:
		if speedup_trail.get("emitting") != null:
			speedup_trail.emitting = false
	my_player.move_and_slide(direction * current_speed)
