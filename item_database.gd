extends Node

var dropped_item = preload("res://dropped_item.tscn")
var items = {"wood": item.new("wood", 20, load("res://wood.svg"),
				[preload("res://Tree.tscn"),
				preload("res://Trunk.tscn")]),
			"tomato": consumable.new("tomato", 20, load("res://tomato.svg"), 
				[preload("res://TomatoBush.tscn")], 0.2, 0.1),
			"stone": item.new("stone", 20, load("res://stone.svg"), 
				[preload("res://Rock.tscn"),
				preload("res://Rock2.tscn")]),
			"orange": consumable.new("orange", 20, load("res://orange.svg"),
				[preload("res://OrangeBush.tscn")], 0.2, 0.1)}
var effects = {"bush_drag": effect.new("bush_drag", 0.5)}
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
	if item.name == "wood":
		print(randi()%item.spawners.size())
	var instance = item.spawners[randi()%item.spawners.size()].instance()
	instance.global_position = global_position
	game.add_child(instance)