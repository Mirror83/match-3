extends Node2D

var game: Game;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_start_game():
	$Menu.visible = false
	game = preload("res://scenes/Game.tscn").instantiate();
	add_child(game);
