extends KinematicBody2D

# moving
var speed = 200

# punching
var punch_change_hand = 0.8
var punch_current_hand = true
var punch_queued = false

var direction = Vector2()
var velocity = Vector2()

func _ready():
	$anim.play("idle")

func _anim_process():
	print("check")
	if direction != Vector2.ZERO:
		$anim.current_animation = "move"
	if direction == Vector2.ZERO:
		$anim.current_animation = "idle"
	if Input.is_action_pressed("game_click") or punch_queued:
		$anim.play("punch1" if punch_current_hand else "punch2")
		if randf() < punch_change_hand:
			punch_current_hand = !punch_current_hand
		print("punch")
		$audio.play()
		punch_queued = false


func _physics_process(delta):
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = direction * speed
	move_and_slide(velocity, Vector2(0, -1))

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("game_click"):
		punch_queued = true
