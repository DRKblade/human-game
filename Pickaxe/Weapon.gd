extends Node

export var tool_class: PoolStringArray
export var hit_strength: int
export var use_energy: float = 0.08
export var use_action = "strike"
var hit = Array()
var inactive = Array()
var animation_length
var active = false
var action

func _on_entered(area):
	hit.push_back(area)

func _on_exited(area):
	var index = hit.find(area)
	if index != -1:
		hit.remove(index)

func on_attached(main_animation):
	animation_length = action.my_player.anim.get_animation(main_animation).length

func _physics_process(delta):
	if action.my_player.anim.hit_active:
		for body in hit:
			if body.has_method("on_hit") and inactive.find(body) == -1 and body.get("side") != action.my_player.side:
				my_math.find(tool_class, "nothing")
				body.on_hit(action.my_player, tool_class, hit_strength*animation_length)
				inactive.push_back(body)
				break

func start_hit():
	inactive.clear()

func end_hit():
	pass