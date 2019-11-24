extends TextureButton

class_name MyTextureButton

export var normal_color = Color.white
export var hover_color = Color.white
export var pressed_color = Color.white

export var smoothing = 0.2
var target_value:Color = normal_color

func _process(delta):
	self_modulate = self_modulate + (target_value - self_modulate)*smoothing

func _on_Button_mouse_entered():
	if disabled:
		return
	target_value = hover_color

func _on_Button_mouse_exited():
	if disabled:
		return
	target_value = normal_color


func _on_Button_button_down():
	if disabled:
		return
	target_value = pressed_color

func _on_Button_button_up():
	if disabled:
		return
	target_value = normal_color

