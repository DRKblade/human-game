extends KinematicBody2D

# movement
export var speed = 200

# punch
export var punch_change_hand = 0.8
var punch_current_hand = true
var punch_queued = false
var punch_active = false
var hand_hit = Array()

# inventory
export var max_item = 5
var items = Array()
var itemQty = Array()
var inventory

var direction = Vector2()
var velocity = Vector2()

func _ready():
	if item_database.player == null:
		item_database.player = self
	else:
		print("error: more than one player")
	
	$anim.play("idle")
	
	# inventory
	inventory = $gui.find_node("inventory")
	inventory.set_slot_count(max_item)

func drop_item(item, qty):
	item_database.drop_item(item, global_position, get_global_mouse_position() - global_position, qty)

func _anim_process():
	# movement
	if direction != Vector2.ZERO:
		$anim.current_animation = "move"
	if direction == Vector2.ZERO:
		$anim.current_animation = "idle"
	
	# punch
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
	# movement
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = direction * speed
	move_and_slide(velocity)
	
	# punch
	if punch_active:
		for area in hand_hit:
			if area.is_in_group("punchable"):
				hit(area)

func _process(delta):
	look_at(get_global_mouse_position())
	
	# punch
	if Input.is_action_just_pressed("game_click"):
		punch_queued = true

# punch
func hit(collider):
	collider.on_hit(self)
	punch_active = false

func _on_hand_entered(area):
	hand_hit.push_back(area)

func _on_hand_exited(area):
	hand_hit.remove(hand_hit.find(area))

# inventory
	