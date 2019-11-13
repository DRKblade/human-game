extends Button

class_name inventory_slot

var player_connected
var item
var qty
var crafting = false

func start_crafting():
	$crafting_process.visible = true
	crafting = true

func set_crafting_process(process):
	if process >= 1:
		$crafting_process.visible = false
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

func pressed():
	var player = ItemDatabase.player
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
			ItemDatabase.player.drop_item(self)

func is_empty():
	return item == null

func clear():
	item = null
	$tex.texture = null
	$qty.text = ""
	if ItemDatabase.player.pullout_slot == self:
		ItemDatabase.player.lose_item()


func _mouse_entered():
	ItemDatabase.gui_active += 1

func _mouse_exited():
	ItemDatabase.gui_active -= 1

func deplete_item(amount = 1):
	var new_qty = qty-amount
	if new_qty<0:
		return false
	elif new_qty > 0:
		set_qty(new_qty)
	else:
		clear()
	return true