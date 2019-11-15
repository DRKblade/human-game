extends HBoxContainer

signal inventory_changed

export var player_connected = false
var slot = preload("res://Character/inventory-slot.tscn")
var slot_count = 0

func _ready():
	pass

func set_slot_count(new_slot_count):
	while new_slot_count > slot_count:
		var child = slot.instance()
		child.player_connected = player_connected
		add_child(child)
		slot_count += 1
	
	while new_slot_count < slot_count:
		slot_count -= 1
		var child = get_child(get_child_count()-1)
		child.queue_free()
		
	set_anchors_and_margins_preset(PRESET_CENTER_BOTTOM, PRESET_MODE_KEEP_SIZE)

func drop_slot(slot_index, global_position, direction):
	var dropped = Items.dropped_item.instance()
	var slot = get_child(slot_index)
	if !slot.is_empty():
		dropped.setup(slot.item, global_position, direction, slot.qty)

func has_item(item, qty):
	var sum = 0
	for slot in get_children():
		if slot.item == item:
			sum += slot.qty
			if sum >= qty:
				return true
	return false

func take_item(item, qty):
	for slot in get_children():
		if slot.item == item:
			var taken = min(qty, slot.qty)
			slot.add_qty(-taken)
			qty -= taken
			if qty == 0:
				inventory_changed()
				return

func get_fillable_slot(item):
		var filled_slot = null
		for slot in get_children():
			if !slot.crafting and slot.item == item and slot.qty < item.max_stack:
				filled_slot = slot
				
		if filled_slot == null:
			for slot in get_children():
				if slot.is_empty():
					slot.set_tex(item)
					slot.qty = 0
					filled_slot = slot
					break
		return filled_slot

func fill_item(item, qty):
	while qty > 0:
		var filled_slot = get_fillable_slot(item)
		if filled_slot == null:
			inventory_changed()
			return qty
		
		var transfer = min(qty, item.max_stack - filled_slot.qty)
		filled_slot.add_qty(transfer)
		qty -= transfer
	inventory_changed()
	return 0

func inventory_changed():
	Items._on_player_inventory_changed()