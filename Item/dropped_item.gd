extends Area2D

class_name dropped_item

export var initial_speed = 100
export var deceleration = 40
export var direction_rand = 0.5
export var speed_rand = 0.3
var qty = 1
var item
var speed = 0
var direction = Vector2.ZERO


func setup(item, global_position, direction, qty = 1):
	self.item = item
	$spr.texture = item.texture
	var target = direction.normalized() + Vector2(my_math.rand_abs(direction_rand), my_math.rand_abs(direction_rand))
	self.direction = target.normalized()
	speed = initial_speed * my_math.interpolate(1, target.length(), speed_rand)
	self.global_position = global_position
	set_qty(qty)
	Items.game.add_child(self)

func set_qty(qty):
	self.qty = qty
	$qty.text = "x"+str(qty) if qty>1 else ""
	$delete.start()

func restart_timer():
	$delete.start()

func _process(delta):
	if speed>0:
		position += direction * speed*delta
		speed -= deceleration*delta
	modulate = Color(1,1,1, $delete.time_left/$delete.wait_time)

func _area_entered(area):
	if area.is_in_group("dropped") and area.item == item and area.qty+qty <= item.max_stack and area.speed < speed:
		Items.game.remove_child(self)
		queue_free()
		area.set_qty(area.qty+qty)
		area.restart_timer()


func _on_delete_timeout():
	queue_free()
