extends Node

func _ready():
	if item_database.game == null:
		item_database.game = self
	else:
		print("error: more than one game node")
