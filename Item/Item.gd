extends Node

class_name item

export var max_stack: int
export var texture: Texture

func create_spawner(global_position):
	if $spawners == null:
		print("error: spawners not supported")
		return
	var spawner = $spawners.get_child(randi() % $spawners.get_child_count()).duplicate()
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