extends Area2D

export var side = "zombie"

func on_hit(source, tool_class, hit_strength):
	get_parent().properties["life"].add_hit(-hit_strength)
	$glow/anim.play("pulse-hurt")