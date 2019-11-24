extends "res://Character/basic_action.gd"

var body_hit = Array()

func _on_body_entered(area):
	body_hit.push_back(area)
	if area.has_method("on_enter"):
		area.on_enter(self)

func _on_body_exited(area):
	body_hit.remove(body_hit.find(area))
	if area.has_method("on_exit"):
		area.on_exit(self)

func action():
	if .action():
		yield()
	
	for area in body_hit:
		if area is dropped_item:
			var qty = my_player.inventory.fill_item(area.qty, area)
			if qty == 0:
				area.queue_free()
			elif qty == area.qty:
				return
			else:
				area.init_qty(qty, area)
			my_player.anim.play("pickup1" if get_parent().get_current_hand() else "pickup2")
			yield()