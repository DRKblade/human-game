extends HBoxContainer

var slot = preload("res://inventory-slot.tscn")
var slot_count = 0

func _ready():
	pass

func set_slot_count(new_slot_count):
	while new_slot_count > slot_count:
		slot_count += 1
		add_child(slot.instance())
	while new_slot_count < slot_count:
		slot_count -= 1
		var child = get_child(get_child_count()-1)
		remove_child(child)
		child.queue_free()
	
	var size = slot_count*rect_size.y
	margin_left = -size/2
	margin_right = size/2

func texture_change(slot_index, texture):
	get_child(slot_index).set_tex(texture)

func qty_change(slot_index, qty):
	get_child(slot_index).set_qty(qty)
	