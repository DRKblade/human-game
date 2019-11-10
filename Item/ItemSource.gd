extends structure

class_name item_source

export var stash_count = 20
export var item_name = "tomato"

var item

func _ready():
	item = item_database.items[item_name]

func _on_hit(source):
	if source.inventory.fill_item(item, 100) > 0:
		item_database.drop_item(item, global_position, -pushback_target, 1)
	stash_count-=1
	if stash_count == 0:
		get_parent().remove_child(self)
		queue_free()
