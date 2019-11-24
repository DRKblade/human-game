extends equipable


func create_action():
	var result = .create_action()
	result.equipment = $equipment.duplicate()
	result.equipment.action = result
	return result