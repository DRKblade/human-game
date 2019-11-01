extends KinematicBody2D

# moving
var speed = 200

# punching
var punch_change_hand = 0.8
var punch_current_hand = true
var punch_queued = false
var punch_active = false

# collision
var hand_hit = Array()

var direction = Vector2()
var velocity = Vector2()

func _ready():
	$anim.play("idle")

func _anim_process():
	if direction != Vector2.ZERO:
		$anim.current_animation = "move"
	if direction == Vector2.ZERO:
		$anim.current_animation = "idle"
	
	if Input.is_action_pressed("game_click") or punch_queued:
		$anim.play("punch1" if punch_current_hand else "punch2")
		if randf() < punch_change_hand:
			punch_current_hand = !punch_current_hand
		$audio.play()
		punch_queued = false
		punch_active = true
	else:
		punch_active = false


func _physics_process(delta):
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = direction * speed
	move_and_slide(velocity)
	if punch_active:
		for area in hand_hit:
			if area.is_in_group("punchable"):
				hit(area)
			
func hit(collider):
	collider.move(position)
	punch_active = false

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("game_click"):
		punch_queued = true


func _on_hand_entered(area):
	hand_hit.push_back(area)

func _on_hand_exited(area):
	hand_hit.remove(hand_hit.find(area))
