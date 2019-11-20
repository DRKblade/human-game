extends MyTextureButton

export var item_names: PoolStringArray
export var qtys: PoolIntArray
export var result_name: String
export var result_qty = 1
export var duration: float

func get_ingredient_count(): return item_names.size()
func item_name(index): return item_names[index]
func qty(index): return qtys[index]
func get_result_qty(): return result_qty
func get_duration(): return duration