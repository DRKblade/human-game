extends KinematicBody2D

# moving
var speed = 200

# punching
var punch_change_hand = 0.8
var punch_current_hand = true

var direction = Vector2()
var velocity = Vector2()

func _ready():
    $spr.connect("animation_finished", self, "on_finished")

func on_finished():
	$spr.playing=false
	print("ended")

func _physics_process(delta):
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = direction * speed
	move_and_slide(velocity, Vector2(0, -1))
	if Input.is_action_pressed("game_click") and !$spr.playing:
		$spr.animation = "punch1" if punch_current_hand else "punch2"
		if randf() < punch_change_hand:
			punch_current_hand = !punch_current_hand
		$spr.playing = true
		$spr.frame = 0
		print("punch")
		$audio.play()
	
func _process(delta):
	look_at(get_global_mouse_position())
