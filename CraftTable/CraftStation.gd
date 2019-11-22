extends hittable

export var station_name:String
var inventory = array_inventory.new()
onready var effect = Effects.effects["structure_drag"]

func _enter_tree():
	for child in $inventory.get_children():
		inventory.add_slot(child)
		$inventory.remove_child(child)
	remove_child($inventory)
	$crafter.inventory = inventory

func _on_enter(player):
	player.speed.add_effect(effect)
	player.set_craft_station(station_name, self, true)

func _on_exit(player):
	player.speed.remove_effect(effect)
	player.set_craft_station(station_name, self, false)
	if player.extern_inventory_source == inventory:
		player.exit_extern_inventory()

func _on_hit(source, tool_class, hit_strength):
	if wobbling:
		Items.player.toggle_extern_inventory(inventory)
	return ._on_hit(source, tool_class, hit_strength)

func craft(recipe):
	$crafter.start_crafting(recipe)
	Items.player.show_extern_inventory(inventory)