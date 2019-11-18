extends Node

var item: item
var qty: int = 0
var rot_state = 0

func _ready():
	Items.game.connect("item_process", self, "_on_item_process")

func _set_qty(qty):
	if qty == 0:
		on_emptied()
	else:
		self.qty = qty
		$qty.text = "x"+str(qty) if qty>1 else ""
	

func init_qty(qty, source):
	_set_qty(qty)
	rot_state = 0 if source == null else source.rot_state
	$tex.modulate = Color(1,1,1,1-rot_state)

func add_qty(amount, instance):
	if item.has_method("combine"):
		item.combine(self, instance, amount)
		$tex.modulate = Color(1,1,1,1-rot_state)
	_set_qty(qty+amount)

func reduce_qty(amount):
	_set_qty(qty-amount)

func on_emptied():
	pass

func is_empty():
	return item == null

func set_item(item):
	$tex.texture = item.texture
	self.item = item

func _on_item_process(delta):
	if !is_empty() and item.has_method("item_process"):
		if item.item_process(delta, self):
			on_emptied()
		else:
			$tex.modulate = Color(1,1,1,1-rot_state)