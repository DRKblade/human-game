extends Node

func _ready():
	if item_database.game == null:
		item_database.game = self
	else:
		print("error: more than one game node")

	print("load")
	item_database.spawn_spawner(item_database.items["tomato"], Vector2(200,100))
	item_database.spawn_spawner(item_database.items["orange"], Vector2(250,150))
	item_database.spawn_spawner(item_database.items["wood"], Vector2(-200,100))
	item_database.spawn_spawner(item_database.items["wood"], Vector2(-250,150))
	item_database.spawn_spawner(item_database.items["wood"], Vector2(-200,-150))
	item_database.spawn_spawner(item_database.items["stone"], Vector2(200,-150))
	item_database.spawn_spawner(item_database.items["stone"], Vector2(250,-150))
