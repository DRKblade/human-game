extends Node

export var spawn_range = Vector2(2000,2000)
export var initial_spawn_count = 10

func _ready():
	if Items.game == null:
		Items.game = self
	else:
		print("error: more than one game node")
	
	for i in initial_spawn_count:
		_natural_spawn()

func _natural_spawn():
	Environments.natural_spawn()
