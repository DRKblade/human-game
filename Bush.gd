extends KinematicBody2D

var move_length = 15
var move_duration = 0.2

var move_time = move_duration
var move_target = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	if move_time < move_duration*2:
		move_time += delta
		if move_time < move_duration:
			$spr.position = Vector2.ZERO.linear_interpolate(move_target, move_time / move_duration)
		else:
			$spr.position = move_target.linear_interpolate(Vector2.ZERO, (move_time - move_duration)/move_duration)

func move(from_position : Vector2):
	print(position)
	move_target = (position - from_position).normalized() * move_length
	if move_time < move_duration*2:
		if move_time > move_duration:
			move_time = move_duration*2 - move_time
	else:
		move_time = 0
