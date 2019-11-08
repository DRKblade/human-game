class_name item

var max_stack: int
var texture: Texture
var name: String
var spawners: Array

func _init(name, max_stack, texture = null, spawners = null):
	self.name = name
	self.max_stack = max_stack
	self.texture = texture
	self.spawners = spawners