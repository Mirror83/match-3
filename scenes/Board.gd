extends Node2D
class_name Board

const BOARD_SIZE = 8
const RESPAWN_Y = -200

var board: Array[Array];

var focused_tile_index: Vector2i;
var selected_tile_index;

var screen_size: Vector2;
var tile_size: Vector2;

func _ready():
	screen_size = get_viewport_rect().size
	
	board = _generate_board()
	# Stop-gap for initializing board without a matching configuration
	# Ideally, board should also check whether there is at least one swap
	# which results in a match.
	while has_matches(board):
		_clear_board(board)
		board = _generate_board()
	
	position = Vector2(
		lerpf(0, screen_size.x, 0.7) - (tile_size.x * BOARD_SIZE) / 2, 
		screen_size.y / 2 - (tile_size.y * BOARD_SIZE) / 2
	)
	
	_focus_on_tile(Vector2i(0, 0))
	
func _process(_delta):
	if Input.is_action_just_pressed("calculate_matches"):
		var matches = calculate_matches(board)
		print(matches)
	
	if Input.is_action_just_pressed("highlight_matches"):
		var matches = calculate_matches(board)
		remove_matches(matches, true)
		
	_manage_tile_focus()
	_manage_tile_selection()
	
func _draw():
	var focused_tile_pos = tile_pos_by_index(focused_tile_index)
	draw_rect(
		Rect2(focused_tile_pos - tile_size / 2, tile_size),
		Color(0, 0, 0),
		false,
		3
	)
	
	var selected_tile = _get_tile(selected_tile_index)
	if (selected_tile != null):
		draw_rect(
			Rect2(
				selected_tile.position - selected_tile.tile_size / 2,
				tile_size
			),
			Color(1, 1, 1),
			true
		)

func _clear_board(array: Array[Array]):
	for row in array:
		for tile in row:
			remove_child(tile)
			
	array.clear()

func _generate_board() -> Array[Array]:
	var tile_board: Array[Array] = []
	
	var current_tile = preload("res://scenes/Tile.tscn").instantiate()
	tile_size = current_tile.get_rect().size
	
	var tile_position = tile_size / 2
	
	for i in range(BOARD_SIZE):
		var row = [];
		for j in range(BOARD_SIZE):
			current_tile.set_color_and_variant(randi() % (Tile.COLORS / 2), 0)	
			current_tile.position = Vector2(tile_position.x, tile_position.y)
			
			add_child(current_tile)
			
			row.append(current_tile)
			
			tile_position.x += tile_size.x
			
			current_tile = preload("res://scenes/Tile.tscn").instantiate()
		
		tile_board.append(row);
		
		tile_position.x = tile_size.x / 2
		tile_position.y += tile_size.y
		
	return tile_board
	
	
func _get_tile(index) -> Tile:
	if index == null: return null
	return board[index.x][index.y]

func _set_tile(index: Vector2i, tile: Tile):
	board[index.x][index.y] = tile

func _focus_on_tile(tile_index: Vector2i):
	focused_tile_index = tile_index
	queue_redraw()

func _select_tile(tile_index: Vector2i):
	selected_tile_index = tile_index
	queue_redraw()
	
func tile_pos_by_index(index: Vector2) -> Vector2:
	return Vector2(
	 	tile_size.y / 2 + tile_size.y * index.y,
		tile_size.x / 2 + tile_size.x * index.x
	)

func _manage_tile_focus():
	if Input.is_action_just_pressed("right"):
		var tile_right_index = Vector2i(
			focused_tile_index.x,
			(focused_tile_index.y + 1) % BOARD_SIZE)
		_focus_on_tile(tile_right_index)
		
	elif Input.is_action_just_pressed("left"):
		var tile_left_ndx = Vector2i(
			focused_tile_index.x,
			(BOARD_SIZE + focused_tile_index.y - 1) % BOARD_SIZE)
		_focus_on_tile(tile_left_ndx)
	
	elif Input.is_action_just_pressed("down"):
		var tile_below_ndx = Vector2i(
			(focused_tile_index.x + 1) % BOARD_SIZE,
			focused_tile_index.y)
		_focus_on_tile(tile_below_ndx)
		
	elif Input.is_action_just_pressed("up"):
		var tile_above_ndx = Vector2i(
			(BOARD_SIZE + focused_tile_index.x - 1) % BOARD_SIZE,
			focused_tile_index.y)
		_focus_on_tile(tile_above_ndx)

func _manage_tile_selection():
	if Input.is_action_just_pressed("accept"):
		if (selected_tile_index == null):
			_select_tile(focused_tile_index)
		else:
			if _can_swap(): _swap_tiles()

func _can_swap():
	var horizontally_adjacent = \
		abs(selected_tile_index.y - focused_tile_index.y) == 1
	var vertically_adjacent = \
		abs(selected_tile_index.x - focused_tile_index.x) == 1
	
	var in_same_row = selected_tile_index.x == focused_tile_index.x
	var in_same_col =  selected_tile_index.y == focused_tile_index.y
	
	return (horizontally_adjacent or vertically_adjacent) \
		and (in_same_row or in_same_col)

func _swap_tiles():
	var selected_tile = _get_tile(selected_tile_index)
	var focused_tile = _get_tile(focused_tile_index)
	
	var selected_position = selected_tile.position
	var focused_position = focused_tile.position
	
	var tween =  create_tween()
	tween.set_parallel(true)
	tween.tween_property(selected_tile, "position", focused_position, 0.2)
	tween.tween_property(focused_tile, "position", selected_position, 0.2)
	tween.tween_callback(
		func ():
			selected_tile.position = focused_position
			focused_tile.position = selected_position
			
			_set_tile(selected_tile_index, focused_tile)
			_set_tile(focused_tile_index, selected_tile)
			
			selected_tile_index = null
			var matches = calculate_matches(board);
			remove_matches(matches)
			queue_redraw()
	)

func calculate_matches(array: Array[Array]) -> Array[Array]:
	var all_matches: Array[Array] = [];
	
	# Horizontal matches
	for row in range(BOARD_SIZE):
		var consecutive_matches = 0
		var current_color = null;
		var matches = [];
		
		for col in range(BOARD_SIZE):
			var tile_color = array[row][col].color
			if current_color == null:
				current_color = tile_color
				consecutive_matches += 1
			elif current_color == tile_color:
				consecutive_matches += 1
			else:
				consecutive_matches = 1
				current_color = tile_color
				
			if consecutive_matches == 3:
				for i in range(consecutive_matches):
					matches.append(Vector2i(row, col - i))
				
			if consecutive_matches > 3:
				matches.append(Vector2i(row, col))

		all_matches.append(matches)
	
	# Vertical matches
	for row in range(BOARD_SIZE):
		var consecutive_matches = 0
		var current_color = null;
		var matches = [];
		
		for col in range(BOARD_SIZE):
			var tile_color = array[col][row].color
			if current_color == null:
				current_color = tile_color
				consecutive_matches += 1
			elif current_color == tile_color:
				consecutive_matches += 1
			else:
				consecutive_matches = 1
				current_color = tile_color
				
			if consecutive_matches == 3:
				for i in range(consecutive_matches):
					matches.append(Vector2i(col - i, row))
				
			if consecutive_matches > 3:
				matches.append(Vector2i(col, row))

		all_matches.append(matches)
					
	return all_matches
	
func has_matches(array: Array[Array]) -> bool:
	var all_matches = calculate_matches(array)
	for sub_matches in all_matches:
		if (len(sub_matches) > 0): return true
		
	return false

func remove_matches(matches: Array[Array], highlight: bool = false):
	for row in range(BOARD_SIZE):
		var row_matches = matches[row]
		for index in row_matches:
			var tile = _get_tile(index)
			if highlight == true:
				tile.self_modulate = Color(0,0,0)
			else:
				remove_child(tile)
				tile = null
				_set_tile(index, tile)
	
	for col in range(BOARD_SIZE, BOARD_SIZE*2):
		var col_matches = matches[col]
		for index in col_matches:
			var tile = _get_tile(index)
			if highlight == true:
				tile.self_modulate = Color(0,0,0)
			else:
				remove_child(tile)
				tile = null
				_set_tile(index, tile)
				
	if highlight == true: return
	
	# Reposition remaining tiles
	for row in range(BOARD_SIZE - 1, -1, -1):
		for col in range(BOARD_SIZE):
			var tile_ndx = Vector2i(row, col)
			var tile = _get_tile(tile_ndx)
			
			if tile != null: continue
			print(tile_ndx)
			var removed_tile_pos = Vector2(
			 	tile_size.y / 2 + tile_size.y * col,
				tile_size.x / 2 + tile_size.x * row
			)
			for above_row in range(row, -1, -1):
				var above_tile_ndx = Vector2i(above_row, col)
				var above_tile = _get_tile(above_tile_ndx)
				if above_tile != null:
					var tween = create_tween()
					tween.tween_property(
						above_tile,
						"position",
						 Vector2(removed_tile_pos.x, removed_tile_pos.y),
						 0.4)
					_set_tile(tile_ndx, above_tile)
					_set_tile(above_tile_ndx, null)
					break;
	
	var tween = create_tween()
	tween.set_parallel(true)
	# Replace null tiles with new tiles
	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			var index = Vector2(row, col)
			if _get_tile(index) == null:
				var final_pos = tile_pos_by_index(index)
				
				var new_tile = preload("res://scenes/Tile.tscn").instantiate()
				new_tile.position = Vector2(final_pos.x, RESPAWN_Y)
				new_tile.set_color_and_variant(randi() % (Tile.COLORS / 2), 0)
				
				_set_tile(index, new_tile)
				add_child(new_tile)
				
				tween.tween_property(
					new_tile,
					"position",
					Vector2(final_pos.x, final_pos.y),
					0.4
				)
				
	tween.tween_callback(
		func ():
			var follow_up_matches = calculate_matches(board);
			remove_matches(follow_up_matches)
			queue_redraw()
	)
				
	
