extends equipable

func get_structure():
	var result = $structure.duplicate()
	result.dropped_items = base_items
	result.dropped_qtys = base_qtys
	return result