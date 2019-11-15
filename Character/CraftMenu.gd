extends HBoxContainer

var current_open = null

func child_pressed(child):
	if child == current_open:
		child.set_expanded(false)
		current_open = null
	else:
		if current_open != null:
			current_open.set_expanded(false)
		current_open = child
		child.set_expanded(true)