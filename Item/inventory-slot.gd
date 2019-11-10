extends Button

class_name inventory_slot

var player_connected
var item
var qty

func set_tex(item):
	$tex.texture = item.texture
	self.item = item
	
func set_qty(qty):
	self.qty = qty
	$qty.text = "x"+str(qty) if qty > 1 else ""

func pressed():
	var player = item_database.player
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if player_connected:
			if player.state != player.STATE_FREE:
				player.put_back()
				if player.pullout_slot.item != item:
					player.equip_item(self)
			else:
				player.equip_item(self)
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if item != null:
			if player.pullout_slot == self:
				player.put_back()
			item_database.player.drop_item(self)

func is_empty():
	return item == null

func clear():
	item = null
	$tex.texture = null
	$qty.text = ""
	if item_database.player.pullout_slot == self:
		item_database.player.lose_item()


func _mouse_entered():
	item_database.gui_active += 1

func _mouse_exited():
	item_database.gui_active -= 1

func deplete_item(amount = 1):
	var new_qty = qty-amount
	if new_qty<0:
		return false
	elif new_qty > 0:
		set_qty(new_qty)
	else:
		clear()
	return true