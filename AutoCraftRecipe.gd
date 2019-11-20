extends "res://CraftRecipe.gd"

export var qty_multipler:int = 1
export var duration_multiplier:int = 1

func get_ingredient_count(): return result.base_items.size()
func item_name(index): return result.base_items[index]
func qty(index): return round(result.base_qtys[index]*qty_multipler)
func get_result_qty(): return 1
func get_duration(): return result.base_duration*duration_multiplier