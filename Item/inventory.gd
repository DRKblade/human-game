extends HBoxContainer

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
	
	var size = slot_count*rect_size.y
	margin_left = -size/2
	margin_right = size/2

func drop_slot(slot_index, global_position, direction):
	var dropped = item_database.dropped_item.instance()
	var slot = get_child(slot_index)
	if !slot.is_empty():
		dropped.setup(slot.item, global_position, direction, slot.qty)

func fill_item(item, qty):
	while qty > 0:
		var filled_slot = null
		for i in slot_count:
			var slot = get_child(i)
			if slot.item == item and slot.qty < item.max_stack:
				filled_slot = slot
				
		if filled_slot == null:
			for i in slot_count:
				var slot = get_child(i)
				if slot.is_empty():
					slot.set_tex(item)
					slot.qty = 0
					filled_slot = slot
					break
		if filled_slot == null:
			return qty
		
		var transfer = min(qty, item.max_stack - filled_slot.qty)
		filled_slot.set_qty(filled_slot.qty + transfer)
		qty -= transfer
	return 0
