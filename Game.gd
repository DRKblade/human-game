extends Node

func _ready():
	if ItemDatabase.game == null:
		ItemDatabase.game = self
	else:
		print("error: more than one game node")

	ItemDatabase.items["tomato"].create_spawner(Vector2(200,100))
	ItemDatabase.items["orange"].create_spawner(Vector2(250,150))
	ItemDatabase.items["wood"].create_spawner(Vector2(-200,100))
	ItemDatabase.items["wood"].create_spawner(Vector2(-250,150))
	ItemDatabase.items["wood"].create_spawner(Vector2(-200,-150))
	ItemDatabase.items["stone"].create_spawner(Vector2(200,-150))
	ItemDatabase.items["stone"].create_spawner(Vector2(250,-150))
