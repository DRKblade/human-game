extends item

export var menu_name:String

func on_equip(player):
	player.craft_menu.find_node(menu_name).visible = true
func on_unequip(player):
	player.craft_menu.find_node(menu_name).visible = false