extends ProgressBar

export var text = "Name"
export var smoothing = 0.1
var rising = false
var state_machine
var target_value = 0

func _ready():
	$name.text = text
	state_machine = $anim.get("parameters/playback")
	state_machine.start("off")

func _mouse_entered():
	state_machine.travel("on")

func _mouse_exited():
	state_machine.travel("off")

func set_rising():
	rising = true

func unset_rising():
	rising = false

func _physics_process(delta):
	value += (target_value - value)*smoothing