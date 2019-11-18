extends "res://item_instance.gd"

class_name inventory_slot

signal inventory_changed

var player_connected
var crafting = false

func _ready():
	if player_connected:
		connect("inventory_changed", Items, "_on_player_inventory_changed")

func start_crafting():
	$crafting_process.visible = true
	$crafting_process.value = 1
	crafting = true
	$tex.self_modulate = Color(0.6,0.6,0.6,0.6)

func set_crafting_process(process):
	if process >= 1:
		$crafting_process.visible = false
		$tex.self_modulate = Color(1,1,1,1)
		crafting = false
		return true
	else:
		$crafting_process.value = 1-process
		return false

func _set_qty(qty):
	._set_qty(qty)
	on_inventory_changed()

func _pressed():
	if item != null:
		var player = Items.player
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			if player_connected:
				if player.extern_inventory_source != null:
					init_qty(player.extern_inventory_source.fill_item(qty, self), self)
				elif player.equip_slot != null:
					player.put_back()
					if player.equip_slot.item != item:
						player.equip_item(self)
				else:
					player.equip_item(self)
			else:
				init_qty(player.inventory.fill_item(qty, self), self)
		if Input.is_mouse_button_pressed(BUTTON_RIGHT):
			if item != null:
				if player.pullout_slot == self:
					player.put_back()
				Items.player.drop_item(self)

func on_inventory_changed():
	emit_signal("inventory_changed")

func accept(item):
	return is_empty()

func on_emptied():
	item = null
	$tex.texture = null
	$qty.text = ""
	qty = 0
	rot_state = 0
	$crafting_process.visible = false
	$tex.self_modulate = Color(1,1,1,1)
	if Items.player.pullout_slot == self:
		Items.player.lose_item()

func clear():
	on_emptied()

func deplete_item(amount = 1):
	if qty<amount:
		return false
	else:
		reduce_qty(amount)
	return true

