extends HBoxContainer

class_name inventory

export var player_connected = false
var slot_preload = preload("res://Character/inventory-slot.tscn")
var slot_count = 0

func get_slot(index):
	return get_child(index)
func get_slot_count():
	return get_child_count()
func get_slots():
	return get_children()
func add_slot(slot):
	add_child(slot)

func set_slot_count(new_slot_count):
	while new_slot_count > slot_count:
		var slot = slot_preload.instance()
		slot.player_connected = player_connected
		add_slot(slot)
		slot_count += 1
	
	while new_slot_count < slot_count:
		slot_count -= 1
		var slot = get_slot(get_slot_count()-1)
		slot.queue_free()
		
	set_anchors_and_margins_preset(PRESET_CENTER_BOTTOM, PRESET_MODE_KEEP_SIZE)

func drop_slot(slot_index, global_position, direction):
	var dropped = Items.dropped_item.instance()
	var slot = get_slot(slot_index)
	if !slot.is_empty():
		dropped.setup(slot.item, global_position, direction, slot.qty)

func has_item(item, qty):
	var sum = 0
	for slot in get_slots():
		if slot.item == item:
			sum += slot.qty
			if sum >= qty:
				return true
	return false

func take_item(item, qty):
	for slot in get_slots():
		if slot.item == item:
			var taken = min(qty, slot.qty)
			slot.reduce_qty(taken)
			qty -= taken
			if qty == 0:
				return

func get_fillable_slot(item):
		var filled_slot = null
		for slot in get_slots():
			if !slot.crafting and slot.item == item and slot.qty < item.max_stack:
				filled_slot = slot
				
		if filled_slot == null:
			for slot in get_slots():
				if slot.accept(item):
					slot.set_item(item)
					slot.qty = 0
					filled_slot = slot
					break
		return filled_slot
func fill_item(qty, instance):
	return _fill_item(instance.item, qty, instance)
func fill_item_new(item, qty):
	return _fill_item(item, qty, null)
func _fill_item(item, qty, instance):
	if item == null:
		print("warning: filling null item")
		return
	while qty > 0:
		var filled_slot = get_fillable_slot(item)
		if filled_slot == null:
			return qty
		
		var transfer = min(qty, item.max_stack - filled_slot.qty)
		filled_slot.add_qty(transfer, instance)
		qty -= transfer
	return 0