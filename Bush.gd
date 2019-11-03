extends KinematicBody2D

export var move_length = 15
export var move_duration = 0.15
export var stash_count = 20

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

func on_hit(source):
	move_target = (position - source.position).normalized() * move_length
	if move_time < move_duration*2:
		if move_time > move_duration:
			move_time = move_duration*2 - move_time
	else:
		move_time = 0
	
	if source.is_in_group("player"):
		var item = item_database.items["tomato"]
		if source.inventory.fill_item(item, 100) > 0:
			item_database.drop_item(item, global_position, -move_target, 1)
		stash_count-=1
		if stash_count == 0:
			get_parent().remove_child(self)
			queue_free()
