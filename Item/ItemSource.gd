extends structure

class_name item_source

export var stash_count = 20
export var required_tool_class: String
export var item_drop = 1.0

var item

func _on_hit(source, tool_class, hit_strength):
	prints("on_take", my_math.find(tool_class, required_tool_class))
	if my_math.find(tool_class, required_tool_class) != -1:
		var drop_count = min(my_math.rand_rounding(item_drop*hit_strength), stash_count)
		prints("take", drop_count)
		if ItemDatabase.player.inventory.fill_item(item, drop_count) > 0:
			ItemDatabase.drop_item(item, global_position, -pushback_target, drop_count)
		stash_count-=drop_count
		if stash_count == 0:
			get_parent().remove_child(self)
			queue_free()
