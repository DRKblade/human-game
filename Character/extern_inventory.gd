extends Control

var source

func _ready():
	Items.add_main_player_stuff("extern_inventory", self)

func close():
	source = null
	for child in get_children():
		remove_child(child)
	get_parent().visible = false

func open(inventory):
	source = inventory
	for child in get_children():
		remove_child(child)
	for slot in inventory.get_slots():
		add_child(slot)
	get_parent().visible = true

func toggle(inventory):
	if source == null:
		open(inventory)
	else:
		close()
