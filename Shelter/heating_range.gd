extends Area2D

onready var effect = Effects.effects["fire_heating"]

func _on_entered(body):
	if body is player:
		body.heating.add_effect(effect)


func _on_exited(body):
	if body is player:
		body.heating.remove_effect(effect)
