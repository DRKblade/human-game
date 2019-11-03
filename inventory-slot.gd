extends Button

signal slot_pressed

var item_name
var qty

func set_tex(item):
	$tex.texture = item.texture
	item_name = item.name
	
func set_qty(qty):
	self.qty = qty
	$qty.text = "x"+str(qty)

func pressed():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		emit_signal("slot_pressed")
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if item_name != null:
			item_database.player.drop_item(item_database.items[item_name], qty)
			clear()

func is_empty():
	return item_name == null

func clear():
	item_name = null
	$tex.texture = null
	$qty.text = ""

func get_item():
	return item_database[item_name]