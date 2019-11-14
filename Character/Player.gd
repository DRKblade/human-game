extends KinematicBody2D

class_name player

const STATE_BUSY = 1
const STATE_FREE = 2
const STATE_HALF_BUSY = 3

var state = STATE_FREE
var action_queue = PoolStringArray()

# status
var life = 0.9
var hunger = 1
var temperature = 1
var energy = 0.5
var hunger_deplete = 0.005
var temperature_deplete = 0.05
var life_deplete = 0.05
var life_regain = 0.05
var heating = 0
var energy_deplete = 0.1
var energy_regain = 0
var energy_accel = 0.01
var energy_hunger_deplete = 0.1
var stat_low = 0.1

# movement
export var base_speed = 200
var speed:stat = stat.new(base_speed)
var direction = Vector2()
var speedup_energy = 0.1
var speedup_multiplier = 1.5
var last_speedup = false

# punch
export var change_hand = 0.8
export var hit_active = false
export var hand_tool_class = PoolStringArray(["hand"])
export var hand_hit_strength = 1.0
var active_hitter
var current_hand = true
var hand_hit = Array()
var punch_energy = 0.04
var punch_animation_length

# inventory
export var max_item = 10
var body_hit = Array()
var inventory

# pickup

# pull-out
var equip_node
var equip_slot = null
var pullout_slot = null

# drop item
var dropped_slot

func _ready():
	if Items.player == null:
		Items.player = self
	else:
		print("error: more than one player")
	
	$anim.play("move")
	$gui/margin/status/life.set_rising()
	
	# inventory
	$gui/margin/inventory.set_slot_count(max_item)
	inventory = $gui/margin/inventory
	
	# pull-out
	equip_node = $body/hand1/equip
	
	$crafter.inventory = inventory
	inventory.fill_item(Items.items["wood"], 100)
	inventory.fill_item(Items.items["stone"], 100)
	$body/hand_weapon.player = self
	$body/hand_weapon.animation_length = $anim.get_animation("punch1").length
	set_status()

func craft(recipe):
	$crafter.start_crafting(recipe)

func equip_item(slot):
	if !slot.is_empty() and slot.item.use_action() != null and anim_find("pullout") == -1:
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
	return Input.is_action_pressed(action_name) and Items.gui_active <= 0

func condition_continuous(action_name):
	return Input.is_action_pressed(action_name)

func anim_pull_out():
	equip_slot = pullout_slot
	var equipment =  equip_slot.item.equipment()
	if equipment == null:
		$body/hand1/equip.texture = equip_slot.item.texture
	else:
		equipment.player = self
		equipment.animation_length = $anim.get_animation(equip_slot.item.use_action()).length
		$body/hand1/equip.add_child(equipment)
	
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
	Items.drop_item(dropped_slot.item, global_position, get_global_mouse_position() - global_position, dropped_slot.qty)
	dropped_slot.clear()
	return "throw1" if get_current_hand() else "throw2"

func anim_punch():
	if energy < punch_energy:
		return
	change_energy(-punch_energy)
	$audio.play()
	active_hitter = $body/hand_weapon
	active_hitter._start_hit()
	return "punch1" if get_current_hand() else "punch2"

func anim_pickup():
	for area in body_hit:
		if area is dropped_item:
			var qty = $gui/margin/inventory.fill_item(area.item, area.qty)
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
	if equip_slot != null:
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

func finish_consume():
	speed.remove_effect("busy")
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
	if Input.is_action_pressed("game_speedup") and direction != Vector2.ZERO and (energy > stat_low or last_speedup):
		current_speed *= speedup_multiplier
		change_energy(-speedup_energy*delta)
		last_speedup = energy != 0
		$speedup_trail.emitting = true
	else:
		$speedup_trail.emitting = false
	move_and_slide(direction * current_speed)
	
	# punch
	if hit_active:
		active_hitter.call("_hit_process")

func process_event(action_name, non_gui):
	if Input.is_action_just_pressed(action_name) and anim_find(action_name) == -1 and (!Items.gui_active>0 or !non_gui):
		action_queue.push_back(action_name)

func _process(delta):
	look_at(get_global_mouse_position())
	
	process_event("game_click", true)
	process_event("game_pickup", true)
	process_event("game_use", false)

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
	if hunger == 0:
		if energy < stat_low:
			life = clamp(life - life_deplete, 0, 1)
		else:
			change_energy(-energy_deplete)
	hunger = clamp(hunger - hunger_deplete, 0, 1)
	
	if temperature == 0:
		life = clamp(life - life_deplete, 0, 1)
	temperature = clamp(temperature + heating*temperature_deplete, 0, 1)
	
	energy_regain += energy_accel
	energy = clamp(energy + energy_regain, 0, 1)
	life = clamp(life + hunger*temperature*energy*life_regain, 0, 1)
	
	if temperature == 0:
		$body/glow/anim.play("pulsate-temperature")
	elif hunger == 0 and energy < stat_low*2:
		$body/glow/anim.play("pulsate-energy")
	elif hunger == 0:
		$body/glow/anim.play("pulsate-hunger")
	elif hunger*temperature*energy > 0.25 and life < 1 and $body/glow/anim.current_animation != "pulsate-life":
		$body/glow/anim.play("pulsate-life")
	
	set_status()

func change_energy(delta):
	if delta < 0:
		energy_regain = 0
		change_hunger(delta*energy_hunger_deplete)
	energy = clamp(energy + delta, 0, 1)
	$gui/margin/status/other_stats/energy.target_value = energy

func change_hunger(delta):
	hunger = clamp(hunger + delta, 0, 1)
	$gui/margin/status/other_stats/hunger.target_value = hunger

func set_status():
	$gui/margin/status/life.target_value = life
	$gui/margin/status/other_stats/hunger.target_value = hunger
	$gui/margin/status/other_stats/temp.target_value = temperature
	$gui/margin/status/other_stats/energy.target_value = energy


func _on_exited():
	pass # Replace with function body.


func _on_entered():
	pass # Replace with function body.