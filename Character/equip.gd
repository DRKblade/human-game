extends Sprite

func _ready():
	clear()

func set_texture(tex):
	_clear()
	texture = tex
	$anim.play("equip")

func set_child(child):
	_clear()
	add_child(child)
	$anim.play("equip")

func clear():
	$anim.play("unequip")

func _clear():
	texture = null
	for child in get_children():
		if child.name != "anim":
			remove_child(child)