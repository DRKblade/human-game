extends KinematicBody2D

const STATE_BUSY = 1
const STATE_FREE = 2
const STATE_HALF_BUSY = 3

var state = STATE_FREE
var action_queue = Array()

# status
var life = 1
var hunger = 1
var temperature = 0
var energy = 0.5
var hunger_deplete = 0.02
var temperature_deplete = 0.1
var life_deplete = 0.05
var life_regain = 0.05
var heating = 0.5
var energy_regain = 0
var energy_accel = 0.02

# movement
export var speed = 200
var direction = Vector2()

# punch
export var change_hand = 0.8
var current_hand = true
var punch_active = false
var hand_hit = Array()
var punch_energy = 0.04

# inventory
export var max_item = 10
var body_hit = Array()
var inventory

# pickup

# pull-out
var equip_node
var pullout_slot

# drop item
var dropped_slot

func _ready():
	if item_database.player == null:
		item_database.player = self
	else:
		print("error: more than one player")
	
	$anim.play("move")
	$gui/status/life.set_rising()
	
	# inventory
	$gui/inventory.set_slot_count(max_item)
	inventory = $gui/inventory
	
	# pull-out
	equip_node = $body/hand1/equip
	
	set_status()

func equip_item(slot):
	if slot.is_empty() or !(slot.item is consumable) or action_queue.find("pullout") != -1:
		return
	action_queue.push_back("pullout")
	pullout_slot = slot

func drop_item(slot):
	action_queue.push_back("drop")
	dropped_slot = slot

func put_back():
	if action_queue.find("put_back") == -1:
		action_queue.push_back("put_back")

func lose_item():
	$body/hand1/equip.texture = null
	put_back()

func get_current_hand():
	if randf() < change_hand:
		current_hand = !current_hand
	return current_hand if state != STATE_HALF_BUSY else false

func _anim_event(action_name, require_free, action_method, additional_condition = "condition_false"):
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

func condition_false(action_name):
	return false

func condition_continuous_non_gui(action_name):
	return Input.is_action_pressed(action_name) and !item_database.gui_active>0

func anim_pull_out():
	state = STATE_BUSY
	$body/hand1/equip.texture = pullout_slot.item.texture
	print("pull")
	return "pull_out"

func anim_use():
	return "consume"

func anim_drop():
	if dropped_slot.is_empty():
		return
	item_database.drop_item(dropped_slot.item, global_position, get_global_mouse_position() - global_position, dropped_slot.qty)
	dropped_slot.clear()
	return "throw1" if get_current_hand() else "throw2"

func anim_punch():
	if energy < punch_energy:
		return
	change_energy(-punch_energy)
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
	$body/hand1/equip.texture = null
	return

func to_half_busy(is_put_back = false):
	state = STATE_FREE if is_put_back else STATE_HALF_BUSY
	return "put_back"

func to_busy():
	state = STATE_BUSY
	return "pull_out"

func _anim_process():
	var next_clip = _anim_get_animation()
	if next_clip == null:
		print("error: no animation clip to play")
	$anim.play(next_clip)

func _anim_get_animation():
	var result
	
	# use item
	result = _anim_event("game_use", false, "anim_use")
	if result != null:
		return result
	
	# put-back
	result = _anim_event("put_back", true, "anim_put_back")
	if result != null:
		return result
	
	# drop item
	result = _anim_event("drop", true, "anim_drop")
	if result != null:
		return result
	
	# pull-out
	result = _anim_event("pullout", true, "anim_pull_out")
	if result != null:
		return result
	
	# punch
	result = _anim_event("game_click", true, "anim_punch", "condition_continuous_non_gui")
	if result != null:
		return result
	
	# pickup
	result = _anim_event("game_pickup", true, "anim_pickup", "condition_continuous_non_gui")
	if result != null:
		return result
	
	# movement
	if direction != Vector2.ZERO:
		if state == STATE_BUSY:
			return to_half_busy()
		return "move"
	
	if direction == Vector2.ZERO:
		return "idle_holding" if state == STATE_BUSY else "idle"

func finish_punch():
	punch_active = false

func finish_consume():
	if pullout_slot.item in consumable:
		pullout_slot.item.on_consume(self)
		pullout_slot.deplete_item()

func _physics_process(delta):
	# movement
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	move_and_slide(direction * speed)
	
	# punch
	if punch_active:
		for area in hand_hit:
			if area.is_in_group("punchable"):
				area.on_hit(self)
				punch_active = false
	

func process_event(action_name, non_gui):
	if Input.is_action_just_pressed(action_name) and action_queue.find(action_name) == -1 and (!item_database.gui_active>0 or !non_gui):
		action_queue.push_back(action_name)

func _process(delta):
	look_at(get_global_mouse_position())
	
	process_event("game_click", true)
	process_event("game_pickup", true)
	process_event("game_use", false)

func _on_hand_entered(area):
	hand_hit.push_back(area)

func _on_hand_exited(area):
	hand_hit.remove(hand_hit.find(area))

# pickup
func _on_body_entered(area):
	body_hit.push_back(area)

func _on_body_exited(area):
	body_hit.remove(body_hit.find(area))

func _status_update():
	if hunger == 0:
		life = clamp(life - life_deplete, 0, 1)
	hunger = clamp(hunger - hunger_deplete, 0, 1)
	
	if temperature == 0:
		life = clamp(life - life_deplete, 0, 1)
	temperature = clamp(temperature + heating*temperature_deplete, 0, 1)
	
	energy_regain += energy_accel
	energy = clamp(energy + energy_regain, 0, 1)
	
	life = clamp(life + hunger*temperature*energy*life_regain, 0, 1)
	
	set_status()

func change_energy(delta):
	energy_regain = 0
	energy += delta
	$gui/status/other_stats/energy.target_value = energy

func change_hunger(delta):
	print(delta)
	hunger += delta
	$gui/status/other_stats/hunger.target_value = hunger

func set_status():
	$gui/status/life.target_value = life
	$gui/status/other_stats/hunger.target_value = hunger
	$gui/status/other_stats/temp.target_value = temperature
	$gui/status/other_stats/energy.target_value = energy
