extends Node2D

const FRAME_WIDTH = 12;
const FRAME_HEIGHT = 9;
const VARIETIES = 6;
const COLORS = FRAME_HEIGHT * 2
const BOARD_SIZE = 8

var tile_coords: Array[Array] = [];
var board: Array[Array];

var focused_tile_index: Vector2i;

var screen_size;
var tile_size;

func _ready():
	screen_size = get_viewport_rect().size
	
	tile_coords = _generate_tile_coords()
	board = _generate_board()
			
	position = Vector2(
		lerpf(0, screen_size.x, 0.5) - (tile_size.x * BOARD_SIZE) / 2, 
		screen_size.y / 2 - (tile_size.y * BOARD_SIZE) / 2
	)
	
	_focus_on_tile(Vector2i(0, 0))
	
func _process(_delta):
	_manage_tile_focus()
	
func _manage_tile_focus():
	if Input.is_action_just_pressed("right"):
		focused_tile_index.y += 1 
		focused_tile_index.y %= BOARD_SIZE
		_focus_on_tile(focused_tile_index)
		
	elif Input.is_action_just_pressed("left"):
		focused_tile_index.y -= 1 
		focused_tile_index.y %= BOARD_SIZE
		_focus_on_tile(focused_tile_index)
	
	elif Input.is_action_just_pressed("down"):
		focused_tile_index.x += 1 
		focused_tile_index.x %= BOARD_SIZE
		_focus_on_tile(focused_tile_index)
		
	elif Input.is_action_just_pressed("up"):
		focused_tile_index.x -= 1 
		focused_tile_index.x %= BOARD_SIZE
		_focus_on_tile(focused_tile_index)

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
	tile_size = current_tile.get_rect().size
	
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

func _focus_on_tile(tile_index: Vector2i):
	var tile = board[tile_index.x][tile_index.y]
	tile.select()
	queue_redraw()
	
func _get_focused_tile():
	return board[focused_tile_index.x][focused_tile_index.y]
	
func _draw():
	var focused_tile = _get_focused_tile()
	draw_rect(Rect2(focused_tile.position - focused_tile.tile_size / 2, tile_size), Color(0, 0, 0), false, 3)
