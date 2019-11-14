extends MyTextureButton

export var item_names: PoolStringArray
export var qtys: PoolIntArray
export var result_name: String
export var duration: float
export var disabled_color = Color.white

var items = Array()
var result

func _ready():
	for name in item_names:
		items.push_back(Items.items[name])
	result = Items.items[result_name]
	Items.connect("player_inventory_changed", self, "update_availability")

func _on_pressed():
	Items.player.craft(self)

func check_recipe(inventory):
	for i in items.size():
		if !inventory.has_item(items[i], qtys[i]):
			return false
	return true

func take_recipe(inventory):
	for i in items.size():
		inventory.take_item(items[i], qtys[i])

func update_availability(inventory):
	disabled = !check_recipe(inventory)
	self_modulate = disabled_color if disabled else normal_color