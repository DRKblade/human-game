extends "res://Character/punch_action.gd"

var hittables = []
export var lookat_smoothing = 0.2
export var lookat_min_distance = 200
export var movement_path: NodePath
var lookat_target = Vector2.ZERO
var lookat = Vector2.ZERO
var slowed = false

func _ready():
	get_node(movement_path).connect("on_move", self, "on_move")

func on_move(slowed):
	self.slowed = slowed

func on_enter(body):
	if body.get("side") != my_player.side:
		if body is player:
			hittables.push_front(body)
		elif body.has_method("on_hit"):
			hittables.push_back(body)

func on_exit(body):
	var index = hittables.find(body)
	if index != -1:
		hittables.remove(index)

func anim_process():
	if hittables.size() > 0:
		if hittables[0] is player or slowed:
			return action()

func _get_proximity(item):
	return -(item.global_position - my_player.global_position).length()

func _physics_process(delta):
	if !my_player.anim.hit_active:
		if hittables.size() > 0:
			
			lookat_target = (hittables[0] if hittables[0] is player else my_math.find_max(hittables, self, "_get_proximity")).global_position
		else:
			lookat_target = $movement/movement.direction * lookat_min_distance + my_player.global_position
	lookat += (lookat_target - lookat) * lookat_smoothing
	my_player.look_at(lookat)
