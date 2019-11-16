extends Button

class_name inventory_slot

signal inventory_changed

var player_connected
var item: item
var qty: int
var crafting = false

func _ready():
	if player_connected:
		connect("inventory_changed", Items, "_on_player_inventory_changed")

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
	print("set text", item.name)
	$tex.texture = item.texture
	self.item = item

func set_qty(qty):
	if qty == 0:
		clear()
	else:
		self.qty = qty
		$qty.text = "x"+str(qty) if qty > 1 else ""
		on_inventory_changed()

func add_qty(amount):
	set_qty(qty+amount)

func _pressed():
	print("pressed")
	if item != null:
		var player = Items.player
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if player_connected:
				if player.extern_inventory_source != null:
					set_qty(player.extern_inventory_source.fill_item(item, qty))
				elif player.state != player.STATE_FREE:
					player.put_back()
					if player.equip_slot.item != item:
						player.equip_item(self)
				else:
					player.equip_item(self)
			else:
				set_qty(player.inventory.fill_item(item, qty))
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			if item != null:
				if player.pullout_slot == self:
					player.put_back()
				Items.player.drop_item(self)

func on_inventory_changed():
	emit_signal("inventory_changed")

func is_empty():
	return item == null

func accept(item):
	return is_empty()

func clear():
	item = null
	$tex.texture = null
	$qty.text = ""
	qty = 0
	$crafting_process.visible = false
	$tex.self_modulate = Color(1,1,1,1)
	if Items.player.pullout_slot == self:
		Items.player.lose_item()
	on_inventory_changed()

func deplete_item(amount = 1):
	var new_qty = qty-amount
	if new_qty<0:
		return false
	elif new_qty > 0:
		set_qty(new_qty)
	else:
		clear()
	return true