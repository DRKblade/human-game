extends inventory

class_name array_inventory

var slots = Array()

func get_slot(index):
	return slots[index]
func get_slot_count():
	return slots.size()
func get_slots():
	return slots
func add_slot(slot):
	slots.push_back(slot)
