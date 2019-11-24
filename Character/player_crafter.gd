extends "res://Crafter.gd"

export var inventory_path: NodePath

func _ready():
	inventory = get_node(inventory_path)
	Items.add_main_player_stuff("crafter", self)
