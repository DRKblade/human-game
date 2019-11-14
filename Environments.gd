extends Node

onready var natural_environment = $natural_spawning

func _ready():
	remove_child($natural_spawning)

func natural_spawn(delta):
	natural_environment.spawn(Rect2(-2000,-2000,4000,4000), delta)
