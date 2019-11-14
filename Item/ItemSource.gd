extends structure

class_name item_source

export var stash_count = 20
export var required_tool_class: String
export var item_drop = 1.0
export var item_name: String
export var decay_rate = 0.2
export var drop_prob = 0.01
var item

func _ready():
	item = Items.items[item_name]
	prints("set item",item.name)

func _on_hit(source, tool_class, hit_strength):
	if my_math.find(tool_class, required_tool_class) != -1:
		var drop_count = min(my_math.rand_rounding(item_drop*hit_strength), stash_count)
		if Items.player.inventory.fill_item(item, drop_count) > 0:
			Items.drop_item(item, global_position, -pushback_target, drop_count)
		lose_stash(drop_count)

func lose_stash(drop_count):
	stash_count-=drop_count
	if stash_count == 0:
		get_parent().remove_child(self)
		queue_free()
	elif stash_count < 0:
		print("error: lose more than stash")

func decay(count, delta):
	if count > stash_count:
		count = stash_count
	if randf() < drop_prob/delta:
		Items.drop_item(item, global_position, Vector2(my_math.rand_abs(1), my_math.rand_abs(1)), count)
	lose_stash(count)

func _decay_process(delta):
	decay(my_math.poisson(decay_rate*delta), delta)
