extends Node

export var spawn_range = Vector2(2000,2000)
export var initial_spawn_count = 3

func _ready():
	if ItemDatabase.game == null:
		ItemDatabase.game = self
	else:
		print("error: more than one game node")
	print("something")

func natural_spawn_setup(item):
	while true:
		print("finish spawn co")
		var structure = yield()
		prints("spawn", structure.name)
		var position = Vector2(my_math.rand_abs(spawn_range.x), my_math.rand_abs(spawn_range.y))
		item.setup_spawner(structure, position)

func _natural_spawn():
	var area = spawn_range.x*spawn_range.y*4
	for item in ItemDatabase.items.values():
		item.natural_spawn(area, natural_spawn_setup(item))

