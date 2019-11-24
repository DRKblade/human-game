extends Node

signal item_process
signal status_process

export var spawn_range = Vector2(2000,2000)
export var initial_spawn_count = 100
export var night_tint: Color

onready var day_temp = Effects.effects["day_heating"]
onready var night_temp = Effects.effects["night_cold"]

export var is_day = true

func _enter_tree():
	Items.game = self

func _ready():
	
	for i in initial_spawn_count:
		Environments.natural_spawn(1)
	$gui.add_root_children($player/gui)
	change_day_night()
	_on_item_process()

func _natural_spawn():
	Environments.natural_spawn($natural_spawn.wait_time)
	for child in get_children():
		if child.has_method("_decay_process"):
			child._decay_process($natural_spawn.wait_time)

func change_day_night():
	is_day = !is_day
	$daynight_anim.play("day" if is_day else "night")
	$player.properties["heating"].add_effect(day_temp if is_day else night_temp)
	$player.properties["heating"].remove_effect(day_temp if !is_day else night_temp)

func _on_item_process():
	emit_signal("item_process", $item_process.wait_time)
	emit_signal("status_process", $item_process.wait_time)