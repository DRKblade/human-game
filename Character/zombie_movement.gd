extends "res://Character/movement.gd"

var players = []

func is_speedup():
	return false

func get_direction():
	if players.size() > 0:
		direction = my_math.my_normalize(players[0].global_position - my_player.global_position)
	else: direction = Vector2.ZERO

func set_player(value):
	my_player = value
	
func on_player_enter(body):
	if body is player and body != my_player:
		players.push_back(body)

func on_player_exit(body):
	if body is player and body != my_player:
		players.remove(players.find(body))