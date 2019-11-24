extends item

class_name equipable

var actions = {}

func get_action(pull_out):
	if actions.get(pull_out.my_player.name) == null:
		actions[pull_out.my_player.name] = create_action()
		actions[pull_out.my_player.name].pullout_action = pull_out
	return actions[pull_out.my_player.name]

func create_action():
	var result = $action.duplicate()
	result.item = self
	return result