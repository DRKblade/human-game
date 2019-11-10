class_name effect

var name: String
var value: float
var stackable: bool

func _init(name, value, stackable = false):
	self.name = name
	self.value = value
	self.stackable = stackable