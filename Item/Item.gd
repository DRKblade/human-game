extends Node

class_name item

export var max_stack: int
export var texture: Texture
export var spawn_rate = 0.005

func create_spawner(global_position):
	if $spawners == null:
		print("error: spawners not supported")
		return
	var spawner = $spawners.get_child(randi() % $spawners.get_child_count()).duplicate()
	setup_spawner(spawner, global_position)

func setup_spawner(spawner, global_position):
	spawner.global_position = global_position
	ItemDatabase.game.add_child(spawner)
	spawner.item = self

func use_action():
	return null

func require_free():
	return true

func on_busy(player):
	pass

func equipment():
	return null

func normalize_spawn_rate():
	var sum = 0
	for spawner in $spawners.get_children():
		sum += spawner.spawn_rate_mul
	for spawner in $spawners.get_children():
		spawner.spawn_rate_mul /= sum

func natural_spawn(area, setup):
	if $spawners != null:
#		normalize_spawn_rate()
		for spawner in $spawners.get_children():
			var spawn_count = 20
			prints(spawner.name, spawn_count)
			for i in spawn_count:
				print ("spawning")
				setup = setup.resume(spawner.duplicate())
				print("finish spawn med")