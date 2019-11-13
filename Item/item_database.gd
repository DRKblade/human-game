extends Node

signal player_inventory_changed

var dropped_item = preload("res://Item/dropped_item.tscn")
var items = Dictionary()
var player
var game
var gui_active = 0

var effects = {"bush_drag": effect.new("bush_drag", 0.5), "busy": effect.new("busy", 0.5)}

func _ready():
	for child in get_children():
		items[child.name] = child
		remove_child(child)
	randomize()

func drop_item(item, global_position, direction, qty):
	var item_instance = dropped_item.instance()
	item_instance.setup(item, global_position, direction, qty)

func _on_player_inventory_changed():
	emit_signal("player_inventory_changed", player.inventory)