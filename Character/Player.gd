extends KinematicBody2D

class_name player

var properties = {}
var postures = {}
var actions = {}
var action_list = []
var active_action
var other_stuff = {}
export var posture:String
export var is_main_player = false

var anim
onready var side = $body.side

func _enter_tree():
	anim = $anim

func _ready():
	$anim.play("idle")
	
	if is_main_player:
		Items.player = self
		Items.main_player["inventory"].fill_item_new(Items.items["wood"], 100)
		Items.main_player["inventory"].fill_item_new(Items.items["stone"], 100)
		Items.main_player["inventory"].fill_item_new(Items.items["orange"], 20)
		Items.main_player["inventory"].fill_item_new(Items.items["iron"], 20)
		Items.main_player["inventory"].fill_item_new(Items.items["paper"], 1)

func add_action(action):
	actions[action.name] = action
	my_math.insert_sorted(action_list, action, self, "get_action_priority")
func remove_action(action):
	actions.erase(action.name)
	action_list.remove(action_list.find(action))
func get_action_priority(action):
	return -action.priority

func _anim_process():
	if active_action != null and active_action.is_valid():
		active_action = active_action.resume()
		if active_action != null:
			return
	for action in action_list:
		active_action = action.anim_process()
		if active_action != null:
			break
	if active_action == null:
		anim.play(postures[posture].idle_anim)

func _unhandled_input(event):
	if is_main_player:
		for action in action_list:
			if action.has_method("unhandled_input") and action.unhandled_input(event):
				get_tree().set_input_as_handled()
				break

func _on_enter(area):
	if area.has_method("on_enter"):
		area.on_enter(self)

func _on_exit(area):
	if area.has_method("on_exit"):
		area.on_exit(self)