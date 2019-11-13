extends TextureButton

class_name MyTextureButton

export var normal_color = Color.white
export var hover_color = Color.white
export var pressed_color = Color.white

func _on_Button_mouse_entered():
	ItemDatabase.gui_active += 1
	if disabled:
		return
	self_modulate = hover_color

func _on_Button_mouse_exited():
	ItemDatabase.gui_active -= 1
	if disabled:
		return
	self_modulate = normal_color


func _on_Button_button_down():
	if disabled:
		return
	self_modulate = pressed_color

func _on_Button_button_up():
	if disabled:
		return
	self_modulate = normal_color

