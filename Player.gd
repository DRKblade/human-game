extends KinematicBody2D

const STATE_BUSY = 1
const STATE_FREE = 2
const STATE_HALF_BUSY = 3

var state = STATE_FREE
var action_queue = Array()

# movement
export var speed = 200
var direction = Vector2()

# punch
export var change_hand = 0.8
var current_hand = true
var punch_active = false
var hand_hit = Array()

# inventory
export var max_item = 5
var body_hit = Array()
var inventory

# pickup

# pull-out
var equip_node
var pullout_slot


func _ready():
	if item_database.player == null:
		item_database.player = self
	else:
		print("error: more than one player")
	
	$anim.play("move")
	
	# inventory
	$gui/inventory.set_slot_count(max_item)
	inventory = $gui/inventory
	
	# pull-out
	equip_node = $body/hand1/equip

func equip_item(slot):
	if slot.is_empty() or slot == pullout_slot:
		return
	action_queue.push_back("pullout")
	pullout_slot = slot

func drop_item(item, qty):
	item_database.drop_item(item, global_position, get_global_mouse_position() - global_position, qty)

func get_current_hand():
	if randf() < change_hand:
		current_hand = !current_hand
	return current_hand if state != STATE_HALF_BUSY else false

func anim_event(action_name, require_free, action_method, additional_condition = "condition_false"):
	var action_id = action_queue.find(action_name)
	if call(additional_condition, action_name) or action_id != -1:
		if require_free:
			if state == STATE_BUSY:
				return to_half_busy()
		elif state == STATE_FREE:
			action_queue.remove(action_id)
			return
		elif state == STATE_HALF_BUSY:
			return to_busy()
		action_queue.remove(action_id)
		return call(action_method)

func anim_pull_out():
	state = STATE_BUSY
	$body/hand1/equip.texture = pullout_slot.item.texture
	print("pull")
	return "pull_out"

func condition_false(action_name):
	return false

func anim_use():
	return "consume"

func condition_continuous_non_gui(action_name):
	return Input.is_action_pressed(action_name) and !item_database.gui_active>0

func anim_punch():
	$audio.play()
	punch_active = true
	return "punch1" if get_current_hand() else "punch2"

func anim_pickup():
	for area in body_hit:
		if area.is_in_group("dropped"):
			var qty = $gui/inventory.fill_item(area.item, area.qty)
			if qty == 0:
				area.queue_free()
			elif qty == area.qty:
				return
			else:
				area.set_qty(qty)
			return "pickup1" if get_current_hand() else "pickup2"

func anim_move():
	return "move"

func anim_put_back():
	state = STATE_FREE
	pullout_slot = null
	$body/hand1/equip.texture = null
	return

func _anim_process():
	var next_clip = _anim_get_animation()
	if next_clip == null:
		print("error: no animation clip to play")
	$anim.play(next_clip)

func _anim_get_animation():
	var result
	
	# use item
	result = anim_event("game_use", false, "anim_use")
	if result != null:
		return result
	
	# pull-out
	result = anim_event("pullout", true, "anim_pull_out")
	if result != null:
		return result
	
	# put-back
	result = anim_event("put_back", true, "anim_put_back")
	if result != null:
		return result
	
	# punch
	result = anim_event("game_click", true, "anim_punch", "condition_continuous_non_gui")
	if result != null:
		return result
	punch_active = false
	
	# pickup
	result = anim_event("game_pickup", true, "anim_pickup", "condition_continuous_non_gui")
	if result != null:
		return result
	
	# movement
	if direction != Vector2.ZERO:
		if state == STATE_BUSY:
			return to_half_busy()
		return "move"
	
	if direction == Vector2.ZERO:
		return "idle_holding" if state == STATE_BUSY else "idle"

func put_back():
	if action_queue.find("put_back") == -1:
		action_queue.push_back("put_back")

func to_half_busy(is_put_back = false):
	state = STATE_FREE if is_put_back else STATE_HALF_BUSY
	print("put")
	return "put_back"

func to_busy():
	state = STATE_BUSY
	return "pull_out"

func _physics_process(delta):
	# movement
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	move_and_slide(direction * speed)
	
	# punch
	if punch_active:
		for area in hand_hit:
			if area.is_in_group("punchable"):
				hit(area)

func process_event(action_name, non_gui):
	if Input.is_action_just_pressed(action_name) and action_queue.find(action_name) == -1 and (!item_database.gui_active>0 or !non_gui):
		action_queue.push_back(action_name)

func _process(delta):
	look_at(get_global_mouse_position())
	
	process_event("game_click", true)
	process_event("game_pickup", true)
	process_event("game_use", false)

# punch
func hit(collider):
	collider.on_hit(self)
	punch_active = false

func _on_hand_entered(area):
	hand_hit.push_back(area)

func _on_hand_exited(area):
	hand_hit.remove(hand_hit.find(area))

# pickup
func _on_body_entered(area):
	body_hit.push_back(area)

func _on_body_exited(area):
	body_hit.remove(body_hit.find(area))
