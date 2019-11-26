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
	player.properties["movement"].add_effect(effect)
	Items.main_player["craft_menu"].get_node(station_name).set_station(self, true)

func _on_exit(player):
	player.properties["movement"].remove_effect(effect)
	Items.main_player["craft_menu"].get_node(station_name).set_station(self, false)
	if Items.main_player["extern_inventory"].source == inventory:
		Items.main_player["extern_inventory"].close()

func _on_hit(source, tool_class, hit_strength):
	if wobbling and source.is_main_player == true:
		Items.main_player["extern_inventory"].toggle(inventory)
	return ._on_hit(source, tool_class, hit_strength)

func craft(recipe):
	$crafter.start_crafting(recipe)
	Items.main_player["extern_inventory"].open(inventory)