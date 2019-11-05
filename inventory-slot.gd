extends Button

var player_connected
var item
var qty

func set_tex(item):
	$tex.texture = item.texture
	self.item = item
	
func set_qty(qty):
	self.qty = qty
	$qty.text = "x"+str(qty)

func pressed():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if player_connected:
			var player = item_database.player
			if player.state != player.STATE_FREE:
				player.put_back()
			else:
				player.equip_item(self)
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if item != null:
			item_database.player.drop_item(item, qty)
			clear()

func is_empty():
	return item == null

func clear():
	item = null
	$tex.texture = null
	$qty.text = ""


func _mouse_entered():
	item_database.gui_active += 1

func _mouse_exited():
	item_database.gui_active -= 1
