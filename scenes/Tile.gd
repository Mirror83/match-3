@tool
class_name Tile
extends Sprite2D

@export var selected = false

var tile_size = get_rect().size

func select():
	selected = true
	
func deselect():
	selected = false
	
