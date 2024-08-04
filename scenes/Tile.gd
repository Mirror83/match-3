@tool
class_name Tile
extends Sprite2D

@export var selected = false

var tile_size = get_rect().size
var color: int;
var variant: int;
	
func set_color_and_variant(new_color: int, new_variant: int):
	color = new_color
	variant = new_variant
	# TODO: Move set_coordinate frames here somehow
	
	
