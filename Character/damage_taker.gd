extends Area2D

export var side = "zombie"
export var critical_effect = ["pulse-hurt", "pulse-energy"]
export var pulse_effect_priorities = {"pulse-temperature": 8, "pulse-hunger": 7, "pulse-energy-half":6, "pulse-temperature-half": 5, "pulse-hunger-half": 4, "pulsate-life": 3}
var pulse_effects = PoolStringArray([])

func _ready():
	Items.game.connect("status_process", self, "status_process")

func on_hit(source, tool_class, hit_strength):
	get_parent().properties["life"].add_hit(-hit_strength)
	ensure_play("pulse-hurt")

func ensure_play(name):
	if critical_effect.find(name) != -1:
		$glow/anim.stop(true)
		$glow/anim.play(name)
	else:
		pulse_effects.push_back(name)

func status_process(delta):
	var chosen_effect
	var chosen_priority=-1
	for effect in pulse_effects:
		priority = pulse_effect_priorities.get(effect, -1)
		if priority > chosen_priority:
			chosen_effect = effect
			chosen_priority = priority
	if chosen_effect != null and critical_effect.find($glow/anim.current_animation) == -1:
		$glow/anim.play(chosen_effect)
	pulse_effects.resize(0)