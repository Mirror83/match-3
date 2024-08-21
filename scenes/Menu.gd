extends CanvasLayer
class_name Menu

signal start_game

func _on_start_button_pressed():
	start_game.emit()

func _on_quit_button_pressed():
	get_tree().quit()
