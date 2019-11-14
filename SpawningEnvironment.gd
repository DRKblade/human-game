extends Node

export var overall_spawn_rate = 1.0
export var spawn_block_area = 20000000.0

func spawn(area:Rect2):
	var spawn_rate = overall_spawn_rate * area.get_area() / spawn_block_area
	prints("area", area.get_area(), spawn_rate)
	for spawner in get_children():
		var spawn_func = spawner.spawn(spawn_rate)
		while spawn_func != null:
			spawn_func = spawn_func.resume(Vector2(rand_range(area.position.x, area.end.x), rand_range(area.position.y, area.end.y)))

