extends Node2D
enum {}

const FRAME_WIDTH = 12;
const FRAME_HEIGHT = 9;
const VARIETIES = 6;
const COLORS = FRAME_HEIGHT * 2
const BOARD_SIZE = 8

var tile_coords: Array[Array] = [];
var board: Array[Array];

var selected_tile: Tile;

var screen_size;


func _ready():
	screen_size = get_viewport_rect().size
	
	tile_coords = _generate_tile_coords()
	board = _generate_board()
	
	selected_tile = board[0][0]
	var tile_size = selected_tile.get_rect().size
	
	position = Vector2(
		lerpf(0, screen_size.x, 0.5) - (tile_size.x * BOARD_SIZE) / 2, 
		screen_size.y / 2 - (tile_size.y * BOARD_SIZE) / 2
	)

func _generate_tile_coords():
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
	
func _generate_board() -> Array[Array]:
	var tile_board: Array[Array] = []
	var current_tile = preload("res://scenes/Tile.tscn").instantiate()
	var tile_size = current_tile.get_rect().size
	var tile_position = tile_size / 2
	
	for i in range(BOARD_SIZE):
		var row = [];
		for j in range(BOARD_SIZE):
			current_tile.set_frame_coords(tile_coords[randi() % COLORS][0])
			current_tile.position = Vector2(tile_position.x, tile_position.y)
			add_child(current_tile)
			
			row.append(current_tile)
			
			tile_position.x += tile_size.x
			
			current_tile = preload("res://scenes/Tile.tscn").instantiate()
		
		tile_board.append(row);
		
		tile_position.x = tile_size.x / 2
		tile_position.y += tile_size.y
		
	return tile_board

