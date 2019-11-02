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
	$anim.play("idle")
	inventory = $gui.find_node("inventory")
	inventory.set_slot_count(max_item)

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
func fill_item(item, qty):
	while qty > 0:
		var item_data = item_database.items[item]
		var index = -1
		for i in items.size():
			if items[i] == item and itemQty[i] < item_data.max_stack:
				index = i
		if index == -1:
			index = items.size()
			if index == max_item:
				return qty
			items.push_back(item)
			itemQty.push_back(0)
			inventory.texture_change(index, item_data.texture)
		var transfer = min(qty, item_data.max_stack - itemQty[index])
		itemQty[index] += transfer
		inventory.qty_change(index, itemQty[index])
		qty -= transfer
	return 0