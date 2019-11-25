extends "res://Character/basic_action.gd"

onready var pullout_action = get_parent().get_parent()

func _ready():
	print("set action")
	$hand_weapon.action = self
	$hand_weapon.on_attached("punch1")

func action():
	if .action():
		yield()
	while true:
		if energy != null:
			if energy.value >= 0:
				energy.add(-$hand_weapon.use_energy)
			else: break
		$audio.play()
		$hand_weapon.start_hit()
		my_player.anim.play("punch1" if get_parent().get_current_hand() else "punch2")
		yield()
		$hand_weapon.end_hit()
		if !Input.is_action_pressed(input_action):
			break
