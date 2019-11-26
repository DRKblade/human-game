extends structure

class_name item_source

export var max_stash_count = 20
export var required_tool_class: String
export var item_drop = 1.0
export var item_name: String
export var decay_rate = 0.1
export var drop_prob = 0.05
export var min_size = 0.6
export var wrong_tool_multiplier = 0.5
var stash_count
var item

func _ready():
	item = Items.items[item_name]
	stash_count = max_stash_count

func _on_drop(source, drop_count):
	drop_to_player(source, drop_count, item)

func drop_to_player(source, drop_count, item):
	var inventory = source.other_stuff.get("inventory")
	if inventory != null:
		drop_count = inventory.fill_item_new(item, drop_count)
	Items.drop_item(item, null, global_position, -pushback_target, drop_count)
	lose_stash(drop_count)

func _on_hit(source, tool_class, hit_strength):
	if my_math.find(tool_class, required_tool_class) != -1:
		_on_drop(source, min(my_math.rand_rounding(item_drop*hit_strength), stash_count))
		return true
	else:
		lose_stash(my_math.rand_rounding(item_drop*hit_strength*wrong_tool_multiplier))
		return false

func lose_stash(drop_count):
	stash_count-=drop_count
	var size = my_math.interpolate(min_size, 1, float(stash_count)/max_stash_count)
	scale = Vector2(size, size)
	if stash_count == 0:
		get_parent().remove_child(self)
		queue_free()
	elif stash_count < 0:
		print("error: lose more than stash")

func decay(count, delta):
	if count > stash_count:
		count = stash_count
	if randf() < drop_prob/delta:
		Items.drop_item(item, null, global_position, my_math.rand_direction(), count)
	lose_stash(count)

func _decay_process(delta):
	decay(my_math.poisson(decay_rate*delta), delta)
