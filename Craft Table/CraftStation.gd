extends structure

export var station_name:String
var inventory = array_inventory.new()

func _ready():
	for child in $inventory.get_children():
		inventory.add_slot(child)
		$inventory.remove_child(child)
	remove_child($inventory)
	$crafter.inventory = inventory

func _on_enter(player):
	player.speed.add_effect("bush_drag")
	player.set_craft_station(station_name, self, true)

func _on_exit(player):
	player.speed.remove_effect("bush_drag")
	player.set_craft_station(station_name, self, false)
	if player.extern_inventory_source == self:
		player.exit_extern_inventory()

func _on_hit(source, tool_class, hit_strength):
	open_inventory()

func open_inventory():
	Items.player.show_extern_inventory(inventory.get_slots(), self)

func craft(recipe):
	$crafter.start_crafting(recipe)
	open_inventory()