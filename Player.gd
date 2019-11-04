extends KinematicBody2D

const STATE_BUSY = 1
const STATE_FREE = 2
const STATE_HALF_BUSY = 3

var state = STATE_FREE

# movement
export var speed = 200
var direction = Vector2()

# punch
export var punch_change_hand = 0.8
var punch_current_hand = true
var punch_queued = false
var punch_active = false
var hand_hit = Array()

# inventory
export var max_item = 5
var body_hit = Array()
var inventory

# pickup
export var pickup_change_hand = 0.8
var pickup_queued = false
var pickup_current_hand = true

# pull-out
var equip_node
var pullout_queued = false
var pullout_slot


func _ready():
	if item_database.player == null:
		item_database.player = self
	else:
		print("error: more than one player")
	
	$anim.play("idle")

	# inventory
	$gui/inventory.set_slot_count(max_item)
	inventory = $gui/inventory
	
	# pull-out
	equip_node = $body/hand1/equip

func equip_item(slot):
	if slot.is_empty():
		return
	pullout_queued = true
	pullout_slot = slot

func drop_item(item, qty):
	item_database.drop_item(item, global_position, get_global_mouse_position() - global_position, qty)

func _anim_process():
	
	# pull-out
	if pullout_queued:
		print("pull")
		$body/hand1/equip.texture = pullout_slot.item.texture
		$anim.play("pull_out")
		pullout_queued = false
		state = STATE_BUSY
		return
	
	# put-back
	if state == STATE_FREE and pullout_slot != null:
		print("free")
		pullout_slot = null
		$body/hand1/equip.texture = null
		pass
	
	# punch
	if (Input.is_action_pressed("game_click") and !item_database.gui_active>0) or punch_queued:
		if state == STATE_BUSY:
			to_half_busy()
			return
		$anim.play("punch1" if punch_current_hand and not state == STATE_HALF_BUSY else "punch2")
		if randf() < punch_change_hand:
			punch_current_hand = !punch_current_hand
		$audio.play()
		punch_queued = false
		punch_active = true
		return
	punch_active = false
	
	# pickup
	if (Input.is_action_pressed("game_pickup") and !item_database.gui_active>0) or pickup_queued:
		if state == STATE_BUSY:
			to_half_busy()
			return
		pickup_queued = false
		for area in body_hit:
			if area.is_in_group("dropped"):
				var qty = $gui/inventory.fill_item(area.item, area.qty)
				if qty == 0:
					area.queue_free()
				elif qty == area.qty:
					return
				else:
					area.set_qty(qty)
				$anim.play("pickup1" if punch_current_hand and not state == STATE_HALF_BUSY else "pickup2")
				if randf() < pickup_change_hand:
					pickup_current_hand = !pickup_current_hand
				return
	
	# movement
	if direction != Vector2.ZERO:
		if state == STATE_BUSY:
			to_half_busy()
			return
		$anim.play("move")
		return
	
	if direction == Vector2.ZERO:
		$anim.play("idle_holding" if state == STATE_BUSY else "idle")

func put_back():
	if state == STATE_BUSY:
		to_half_busy(true)
	else:
		state = STATE_FREE

func to_half_busy(is_put_back = false):
	state = STATE_FREE if is_put_back else STATE_HALF_BUSY
	$anim.play("put_back")

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

func _process(delta):
	look_at(get_global_mouse_position())
	
	# punch
	if Input.is_action_just_pressed("game_click") and !item_database.gui_active>0:
		punch_queued = true
	
	# pickup
	if Input.is_action_just_pressed("game_pickup") and !item_database.gui_active>0:
		pickup_queued = true
		

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
