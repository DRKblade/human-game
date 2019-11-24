extends inventory_slot

signal start_consumption
signal stop_consumption

var consumption: Timer

export var accepted_item_name:String
export var item_take_per_click:int = 5

func accept(item):
	return item.name == accepted_item_name
func on_inventory_changed():
	if qty > 0 and consumption.is_stopped():
		consumption.start()
		reduce_qty(1)
		$fire.self_modulate = Color("ffb300")
		emit_signal("start_consumption")
	.on_inventory_changed()

func _on_consume():
	if qty == 0:
		consumption.stop()
		$fire.self_modulate = Color("ffffff")
		emit_signal("stop_consumption")
	else:
		reduce_qty(1)

func _pressed():
	if item == null:
		var item_obj = Items.items[accepted_item_name]
		var item_count = item_take_per_click - Items.player.inventory.take_item(item_obj, item_take_per_click)
		if item_count != 0:
			set_item(item_obj)
			init_qty(item_count, null)
	else:
		._pressed()
