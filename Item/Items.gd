extends Node

signal player_inventory_changed

var dropped_item = preload("res://Item/dropped_item.tscn")
var items = Dictionary()
var player setget player_set
var game setget game_set

func game_set(value):
	if game == null:
		game = value
	else:
		print("error: more than one game node")

func player_set(value):
	if player == null:
		player = value
	else:
		print("error: more than one player node")

func _ready():
	for child in get_children():
		items[child.name] = child
		remove_child(child)
	randomize()

func drop_item(item, global_position, direction, qty):
	if qty != 0:
		var item_instance = dropped_item.instance()
		item_instance.setup(item, global_position, direction, qty)

func _on_player_inventory_changed():
	emit_signal("player_inventory_changed", player.inventory)