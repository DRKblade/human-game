extends Node

var current_recipe
var crafted_time
var inventory
var result_slot

func start_crafting(recipe):
	if result_slot == null and recipe.check_recipe(inventory):
		result_slot = inventory.get_fillable_slot(recipe.result)
		if result_slot != null:
			recipe.take_recipe(inventory)
			current_recipe = recipe
			crafted_time = 0
			result_slot.start_crafting()

func _process(delta):
	if result_slot != null:
		crafted_time += delta
		if result_slot.set_crafting_process(crafted_time/current_recipe.duration):
			result_slot.set_qty(result_slot.qty+1)
			result_slot = null
