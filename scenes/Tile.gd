@tool
class_name Tile
extends Sprite2D

@export var selected = false

const FRAME_WIDTH = 12;
const FRAME_HEIGHT = 9;
const VARIETIES = 6;
const COLORS = FRAME_HEIGHT * 2

var tile_size = get_rect().size
var color: int;
var variant: int;

static var frame_coords_list := _generate_frame_coords_list();

static func _generate_frame_coords_list() -> Array[Array]:
	var coords: Array[Array] = []
	for i in range(FRAME_HEIGHT):
		var colored_tiles = []
		for j in range(FRAME_WIDTH):
			if (j == VARIETIES):
				coords.push_back(colored_tiles)
				colored_tiles = []
			
			colored_tiles.push_back(Vector2(j, i))
			
		coords.push_back(colored_tiles)
	
	return coords
	
func set_color_and_variant(new_color: int, new_variant: int):
	color = new_color
	variant = new_variant
	set_frame_coords(frame_coords_list[new_color][new_variant])
