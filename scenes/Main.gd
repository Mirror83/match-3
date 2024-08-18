extends Node2D

var game: Game;

func _on_menu_start_game():
	$Menu.visible = false
	game = preload("res://scenes/Game.tscn").instantiate();
	add_child(game);
