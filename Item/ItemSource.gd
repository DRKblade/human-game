extends structure

class_name item_source

export var stash_count = 20
export var required_tool_class: String
export var item_drop = 1.0
export var item_name: String
export var decay_rate = 0.2
export var drop_prob = 0.05
var item

func _ready():
	item = Items.items[item_name]
		

func _on_drop(drop_count):
	drop_to_player(drop_count, item)

func drop_to_player(drop_count, item):
	if Items.player.inventory.fill_item_new(item, drop_count) > 0:
		Items.drop_item(item, null, global_position, -pushback_target, drop_count)
	lose_stash(drop_count)

func _on_hit(source, tool_class, hit_strength):
	if my_math.find(tool_class, required_tool_class) != -1:
		_on_drop(min(my_math.rand_rounding(item_drop*hit_strength), stash_count))

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
		Items.drop_item(item, null, global_position, my_math.rand_direction(), count)
	lose_stash(count)

func _decay_process(delta):
	decay(my_math.poisson(decay_rate*delta), delta)
