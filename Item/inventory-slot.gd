extends Button

class_name inventory_slot

var player_connected
var item
var qty
var crafting = false

func start_crafting():
	$crafting_process.visible = true
	$crafting_process.value = 1
	crafting = true
	$tex.self_modulate = Color(0.5,0.5,0.5,0.5)

func set_crafting_process(process):
	if process >= 1:
		$crafting_process.visible = false
		$tex.self_modulate = Color(1,1,1,1)
		crafting = false
		return true
	else:
		$crafting_process.value = 1-process
		return false

func set_tex(item):
	$tex.texture = item.texture
	self.item = item

func set_qty(qty):
	if qty == 0:
		clear()
	self.qty = qty
	$qty.text = "x"+str(qty) if qty > 1 else ""

func add_qty(amount):
	set_qty(qty+amount)

func pressed():
	var player = Items.player
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if player_connected:
			if player.state != player.STATE_FREE:
				player.put_back()
				if player.equip_slot.item != item:
					player.equip_item(self)
			else:
				player.equip_item(self)
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if item != null:
			if player.pullout_slot == self:
				player.put_back()
			Items.player.drop_item(self)

func is_empty():
	return item == null

func clear():
	item = null
	$tex.texture = null
	$qty.text = ""
	$crafting_process.visible = false
	$tex.self_modulate = Color(1,1,1,1)
	if Items.player.pullout_slot == self:
		Items.player.lose_item()

func deplete_item(amount = 1):
	var new_qty = qty-amount
	if new_qty<0:
		return false
	elif new_qty > 0:
		set_qty(new_qty)
	else:
		clear()
	return true