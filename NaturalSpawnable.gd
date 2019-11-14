extends Node

export var spawn_rate_mul: float = 1
export var min_comfortable_distance_squared: float = 1600.0

func setup_node(node, global_position):
	node.global_position = global_position
	Items.game.add_child(node)

func check_distance(global_position):
	for child in Items.game.get_children():
		var other_position = child.get("global_position")
		if other_position != null and (other_position - global_position).length_squared() < min_comfortable_distance_squared:
			return false
	return true

func spawn(spawn_rate):
	var spawn_count = my_math.poisson(spawn_rate*spawn_rate_mul)
	for i in spawn_count:
		var position = yield()
		if check_distance(position):
			setup_node(get_child(randi()%get_child_count()).duplicate(), position)