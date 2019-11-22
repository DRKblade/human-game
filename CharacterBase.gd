extends KinematicBody2D

const STATE_BUSY = 1
const STATE_FREE = 2
const STATE_HALF_BUSY = 3

var state = STATE_FREE
var action_queue = PoolStringArray()
var prev_action

# status
var life = 0.9
var temperature:float = 1
var temperature_deplete:float = 0.05
var life_deplete = 0.05
var heating = stat.new(0)

# movement
export var base_speed = 200
var speed:stat = stat.new(base_speed)
var direction = Vector2()

# punch
export var change_hand = 0.8
export var hit_active = false
export var hand_hit_strength = 1.0
var active_hitter
var current_hand = true
var hand_hit = Array()

# inventory
export var max_item = 10
var body_hit = Array()

# pull-out
var equip_node
var equip_slot = null
var pullout_slot = null

# drop item
var dropped_slot

func _ready():
	Items.player = self
	
	$anim.play("move")
	
	# inventory
#	inventory.set_slot_count(max_item)
	
	# pull-out
	equip_node = $body/hand1/equip
	$body/hand_weapon.player = self
	$body/hand_weapon.animation_length = $anim.get_animation("punch1").length
	heating.connect("value_changed", self, "heating_changed")

func heating_changed(value):
	$dark_vision.target_value = float(-value if value < 0 else 0)

func equip_item(slot: inventory_slot):
	if !slot.is_empty() and slot.item and anim_find("pullout") == -1:
		action_queue.push_back("pullout")
		pullout_slot = slot

func drop_item(slot):
	action_queue.push_back("drop")
	dropped_slot = slot

func put_back():
	if anim_find("put_back") == -1:
		action_queue.push_back("put_back")

func lose_item():
	$body/hand1/equip.texture = null
	put_back()

func get_current_hand():
	if randf() < change_hand:
		current_hand = !current_hand
	return current_hand if state != STATE_HALF_BUSY else false

func anim_find(action_name):
	for i in action_queue.size():
		if action_queue[i] == action_name:
			return i
	return -1

func _anim_event(action_name, require_free, action_method, additional_condition = "condition_false"):
	var action_id = anim_find(action_name)
	if call(additional_condition, action_name) or action_id != -1:
		prev_action = action_name
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

func condition_continuous(action_name):
	return action_name == prev_action and Input.is_action_pressed(action_name)

func anim_pull_out():
	equip_slot = pullout_slot
	var equipment =  equip_slot.item.equipment()
	if equipment == null:
		$body/hand1/equip.texture = equip_slot.item.texture
	else:
		equipment.player = self
		equipment.animation_length = $anim.get_animation(equip_slot.item.use_action()).length
		$body/hand1/equip.add_child(equipment)
	
	if equip_slot.item.has_method("on_equip"):
		equip_slot.item.on_equip(self)
	
	if equip_slot.item.require_free():
		state = STATE_HALF_BUSY
	else:
		state = STATE_BUSY
		return "pull_out"

func anim_use():
	var use_action = equip_slot.item.use_action()
	if use_action != null:
		equip_slot.item.on_busy(self)
	active_hitter = $body/hand1/equip.get_child(0)
	if active_hitter != null:
		active_hitter._start_hit()
	return use_action

func anim_drop():
	if dropped_slot.is_empty():
		return
	Items.drop_item(dropped_slot.item, dropped_slot, global_position, get_global_mouse_position() - global_position, dropped_slot.qty)
	dropped_slot.clear()
	return "throw1" if get_current_hand() else "throw2"

func anim_punch():
	$audio.play()
	active_hitter = $body/hand_weapon
	active_hitter._start_hit()
	return "punch1" if get_current_hand() else "punch2"

#func anim_pickup():
#	for area in body_hit:
#		if area is dropped_item:
#			var qty = inventory.fill_item(area.qty, area)
#			if qty == 0:
#				area.queue_free()
#			elif qty == area.qty:
#				return
#			else:
#				area.init_qty(qty, area)
#			return "pickup1" if get_current_hand() else "pickup2"

func anim_move():
	return "move"

func anim_put_back():
	state = STATE_FREE
	if equip_slot.item != null and equip_slot.item.has_method("on_unequip"):
		equip_slot.item.on_unequip(self)
	equip_slot = null
	if $body/hand1/equip.get_child_count() == 0:
		$body/hand1/equip.texture = null
	else:
		$body/hand1/equip.remove_child($body/hand1/equip.get_child(0))
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
	if equip_slot != null and !equip_slot.is_empty():
		result = _anim_event("game_use", equip_slot.item.require_free(), "anim_use", "condition_continuous")
		if result != null:
			return result
		# put-back
		result = _anim_event("put_back", true, "anim_put_back")
		if result != null:
			return result
	
	# pull-out
	if pullout_slot != null:
		result = _anim_event("pullout", true, "anim_pull_out")
		if result != null:
			return result
	
	# drop item
	result = _anim_event("drop", true, "anim_drop")
	if result != null:
		return result
	
	
	# punch
	result = _anim_event("game_click", true, "anim_punch", "condition_continuous")
	if result != null:
		return result
	
	# pickup
	result = _anim_event("game_pickup", true, "anim_pickup", "condition_continuous")
	if result != null:
		return result
	
	prev_action = null
	# movement
	if direction != Vector2.ZERO:
		if state == STATE_BUSY:
			return to_half_busy()
		return "move"
	
	if direction == Vector2.ZERO:
		return "idle_holding" if state == STATE_BUSY else "idle"

func finish_consume():
	if equip_slot.item is consumable:
		equip_slot.item.on_use(self)
		equip_slot.deplete_item()
		if equip_slot.is_empty():
			equip_slot = null

func _physics_process(delta):
	# movement
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var current_speed = speed.actual_value
	move_and_slide(direction * current_speed)
	
	# punch
	if hit_active:
		active_hitter.call("_hit_process")

func process_event(action_name):
	if Input.is_action_just_pressed(action_name) and anim_find(action_name) == -1:
		action_queue.push_back(action_name)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

func _unhandled_input(event):
#	if event is InputEventMouseButton:
	process_event("game_click")
	process_event("game_pickup")
	process_event("game_use")

# pickup
func _on_body_entered(area):
	body_hit.push_back(area)
	if area.has_method("on_enter"):
		area.on_enter(self)

func _on_body_exited(area):
	body_hit.remove(body_hit.find(area))
	if area.has_method("on_exit"):
		area.on_exit(self)

func _status_update():
	
	if temperature == 0:
		life = clamp(life - life_deplete, 0, 1)
	temperature = clamp(temperature + heating.actual_value*temperature_deplete, 0, 1)
	
	if temperature == 0:
		$body/glow/anim.play("pulse-temperature")