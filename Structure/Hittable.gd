extends structure

class_name hittable

export var health:float
export var regen:float
var dropped_items:PoolStringArray
var dropped_qtys:PoolIntArray

onready var current_health = health

func _process(delta):
	current_health = min(current_health+regen*delta, health)
	modulate = Color(1,1,1,current_health/health)
	if current_health <= 0:
		for i in dropped_items.size():
			Items.drop_item(Items.items[dropped_items[i]], null, global_position, my_math.rand_direction(), dropped_qtys[i])
		Items.game.remove_child(self)
		queue_free()

func _on_hit(source, tool_class, hit_strength):
	current_health -= hit_strength