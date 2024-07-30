extends Node2D


var screen_size: Vector2
var end_position: Vector2
var start_position: Vector2
var timer = 0
const MOVE_DURATION = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	var bird_size = $Bird.get_rect().size
	start_position = Vector2(0 + bird_size.x, screen_size.y / 2)
	end_position = Vector2(screen_size.x - bird_size.x, screen_size.y / 2)
	$Control/Label.text = "%d" % timer
	$Bird.position = start_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < MOVE_DURATION:
		timer += delta
		$Control/Label.text = "%d" % timer
		$Bird.position = start_position.lerp(end_position, timer / MOVE_DURATION)
	
