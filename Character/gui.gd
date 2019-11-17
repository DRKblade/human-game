extends CanvasLayer

export var modulate = Color.white setget set_modulate

func set_modulate(color):
	for child in get_children():
		child.modulate = color

func add_root_children(root):
	for child in root.get_children():
		root.remove_child(child)
		add_child(child)