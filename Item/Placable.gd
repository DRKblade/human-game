extends item

func structure():
	var result = $structure.duplicate()
	result.dropped_items = base_items
	result.dropped_qtys = base_qtys
	return result

func usable():
	return true
