extends "res://CraftRecipe.gd"

export var qty_multipler: float = 1
export var duration_multiplier: float = 1
export var batch_multiplier: float = 1

func get_ingredient_count(): return result.base_items.size()
func item_name(index): return result.base_items[index]
func qty(index): return round(result.base_qtys[index]*qty_multipler*batch_multiplier)
func get_result_qty(): return my_math.rand_rounding(batch_multiplier)
func get_duration(): return result.base_duration*duration_multiplier*batch_multiplier