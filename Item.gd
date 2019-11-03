class_name Item

var max_stack
var texture
var name

func _init(name, max_stack, texture = null):
	self.name = name
	self.max_stack = max_stack
	self.texture = texture