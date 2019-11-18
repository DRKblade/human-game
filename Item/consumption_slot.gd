extends inventory_slot

signal start_consumption
signal stop_consumption

var consumption: Timer

export var accepted_item_name:String

func accept(item):
	return item.name == accepted_item_name
func on_inventory_changed():
	print("called")
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
