extends MyTextureButton
export var disabled_color = Color.white

func get_ingredient_count():pass
func item_name(index):pass
func qty(index):pass
func get_result_qty():pass
func get_duration():pass

export var result_name:String

var items = Array()
var result: item

func _ready():
	result = Items.items[result_name]
	for i in get_ingredient_count():
		items.push_back(Items.items[item_name(i)])
	Items.connect("player_inventory_changed", self, "update_availability")
	texture_normal = result.texture

func _on_pressed():
	if get_parent().get_parent().get_parent().has_method("get_active_station"):
		get_parent().get_parent().get_parent().get_active_station().craft(self)
	else:
		Items.player.craft(self)

func check_recipe(inventory):
	for i in items.size():
		if !inventory.has_item(items[i], qty(i)):
			return false
	return true

func take_recipe(inventory):
	for i in items.size():
		inventory.take_item(items[i], qty(i))

func update_availability(inventory):
	disabled = !check_recipe(inventory)
	self_modulate = disabled_color if disabled else normal_color