extends Node

var item = preload("res://Item.gd")
var consumable = preload("res://Consumable.gd")
var dropped_item = preload("res://dropped_item.tscn")
var items = {"wood": item.new("wood", 20, load("res://wood.svg")),
			"tomato": consumable.new("tomato", 20, load("res://tomato.svg"), 0.2, 0.1),
			"stone": item.new("stone", 20, load("res://stone.svg")),
			"orange": consumable.new("orange", 20, load("res://orange.svg"), 0.2, 0.1)}
var player
var game
var gui_active = 0

func drop_item(item, global_position, direction, qty):
	var item_instance = dropped_item.instance()
	item_instance.setup(item, global_position, direction, qty)