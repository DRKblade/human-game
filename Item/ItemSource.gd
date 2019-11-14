extends structure

class_name item_source

export var stash_count = 20
export var required_tool_class: String
export var item_drop = 1.0
export var item_name: String

var item

func _ready():
	item = Items.items[item_name]
	prints("set item",item.name)

func _on_hit(source, tool_class, hit_strength):
	if my_math.find(tool_class, required_tool_class) != -1:
		var drop_count = min(my_math.rand_rounding(item_drop*hit_strength), stash_count)
		if Items.player.inventory.fill_item(item, drop_count) > 0:
			Items.drop_item(item, global_position, -pushback_target, drop_count)
		stash_count-=drop_count
		if stash_count == 0:
			get_parent().remove_child(self)
			queue_free()
