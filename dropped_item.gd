extends Area2D

export var initial_speed = 100
export var deceleration = 40
export var direction_rand = 0.5
export var speed_rand = 0.3
var qty = 1
var item_name
var max_stack
var speed = 0
var direction = Vector2.ZERO


func setup(item, global_position, direction, qty = 1):
	$spr.texture = item.texture
	var target = direction.normalized() + Vector2(my_math.rand_abs(direction_rand), my_math.rand_abs(direction_rand))
	self.direction = target.normalized()
	speed = initial_speed * my_math.interpolate(1, target.length(), speed_rand)
	self.global_position = global_position
	set_qty(qty)
	max_stack = item.max_stack
	item_name = item.name
	item_database.game.add_child(self)

func set_qty(qty):
	self.qty = qty
	$qty.text = "x"+str(qty) if qty>1 else ""

func restart_timer():
	$delete.start()

func _process(delta):
	if speed>0:
		position += direction * speed*delta
		speed -= deceleration*delta
	


func _area_entered(area):
	if area.is_in_group("dropped") and area.item_name == item_name and area.qty+qty <= max_stack and area.speed < speed:
		get_parent().remove_child(self)
		queue_free()
		area.set_qty(area.qty+qty)
		area.restart_timer()


func _on_delete_timeout():
	get_parent().remove_child(self)
	queue_free()
