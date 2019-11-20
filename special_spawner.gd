extends item_source

export var special_item_name: String
export var min_drop_count: int
export var drop_multiplier: float

onready var special_item = Items.items[special_item_name]

func _on_drop(drop_count):
	._on_drop(drop_count)
	if drop_count >= min_drop_count:
		drop_to_player(my_math.rand_rounding(drop_count*drop_multiplier), special_item)
