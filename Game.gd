extends Node

export var spawn_range = Vector2(2000,2000)
export var initial_spawn_count = 100
export var night_tint: Color

var is_day = false

func _ready():
	Items.game = self
	
	for i in initial_spawn_count:
		Environments.natural_spawn(1)
	$gui.add_root_children($Player.gui)
	change_day_night()

func _natural_spawn():
	Environments.natural_spawn($natural_spawn.wait_time)
	for child in get_children():
		if child.has_method("_decay_process"):
			child._decay_process($natural_spawn.wait_time)

func change_day_night():
	is_day = !is_day
	$daynight_anim.play("day" if is_day else "night")
