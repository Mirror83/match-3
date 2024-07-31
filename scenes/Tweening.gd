extends Node2D


var screen_size: Vector2
var end_position: Vector2
var start_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	var bird_size = $Bird.get_rect().size
	start_position = Vector2(0 + bird_size.x, screen_size.y / 2)
	end_position = Vector2(screen_size.x - bird_size.x, screen_size.y / 2)
	$Bird.position = start_position
	$Bird.modulate = Color(1, 1, 1, 0)
	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	
	tween.tween_property($Bird, "modulate", Color(1, 1, 1, 1), 5)
	tween.tween_property($Bird, "position", end_position, 5)

	
