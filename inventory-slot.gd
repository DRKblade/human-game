extends ColorRect

func set_tex(texture):
	$tex.texture = texture
	
func set_qty(qty):
	$qty.text = "x"+str(qty)
