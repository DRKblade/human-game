extends Node

var dropped_item = preload("res://Item/dropped_item.tscn")
var items = {"wood": item.new("wood", 20, load("res://Craft Table/craft-table-item.svg"),
				[preload("res://Wood/Tree.tscn"),
				preload("res://Wood/Trunk.tscn")]),
			"tomato": consumable.new("tomato", 20, load("res://Bushes/tomato.svg"), 
				[preload("res://Bushes/TomatoBush.tscn")], 0.2, 0.1),
			"orange": consumable.new("orange", 20, load("res://Bushes/orange.svg"),
				[preload("res://Bushes/OrangeBush.tscn")], 0.2, 0.1),
			"stone": item.new("stone", 20, load("res://Stone/stone.svg"), 
				[preload("res://Stone/Rock.tscn"),
				preload("res://Stone/Rock2.tscn")])}
var effects = {"bush_drag": effect.new("bush_drag", 0.5), "busy": effect.new("busy", 0.5)}
var player
var game
var gui_active = 0

func _ready():
	print("random")
	randomize()

func drop_item(item, global_position, direction, qty):
	var item_instance = dropped_item.instance()
	item_instance.setup(item, global_position, direction, qty)

func spawn_spawner(item: item, global_position):
	var instance = item.spawners[randi()%item.spawners.size()].instance()
	instance.global_position = global_position
	instance.item_name = item.name
	game.add_child(instance)