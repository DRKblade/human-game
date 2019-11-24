extends "res://Character/basic_action.gd"

export var inventory_path: NodePath
var body_hit = Array()
onready var inventory = get_node(inventory_path)

func _on_body_entered(area):
	body_hit.push_back(area)

func _on_body_exited(area):
	body_hit.remove(body_hit.find(area))

func action():
	if .action():
		yield()
	
	for area in body_hit:
		if area is dropped_item:
			var qty = inventory.fill_item(area.qty, area)
			if qty == 0:
				area.queue_free()
			elif qty == area.qty:
				return
			else:
				area.init_qty(qty, area)
			my_player.anim.play("pickup1" if get_parent().get_current_hand() else "pickup2")
			yield()