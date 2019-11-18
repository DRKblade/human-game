extends Node

var current_recipe = Array()
var crafted_time = 0
var inventory
var result_slot = Array()
var paused = false setget set_paused

func set_paused(value):
	paused = value

func start_crafting(recipe):
	if recipe.check_recipe(Items.player.inventory):
		var slot = inventory.get_fillable_slot(recipe.result)
		if slot != null:
			result_slot.push_back(slot)
			recipe.take_recipe(Items.player.inventory)
			current_recipe.push_back(recipe)
			slot.start_crafting()

func _process(delta):
	if result_slot.size() > 0 and (!paused or crafted_time < 0.1):
		crafted_time += delta
		if result_slot[0].set_crafting_process(crafted_time/current_recipe[0].duration):
			result_slot.pop_front()
			inventory.fill_item_new(current_recipe[0].result, current_recipe[0].result_qty)
			current_recipe.pop_front()
			crafted_time = 0
			if result_slot.size() > 0 and result_slot[0].qty == 0:
				result_slot[0].clear()
				result_slot[0] = inventory.get_fillable_slot(current_recipe[0].result)
				result_slot[0].start_crafting()
