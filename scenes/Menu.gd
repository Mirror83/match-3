extends CanvasLayer
class_name Menu

signal start_game

func _ready() -> void:
	if OS.has_feature("web"):
		# Remove the quit button because it doesn't really do anything
		# but make the game unresponsive on web
		var quit_button: Button = get_node(
			"VBoxContainer/VBoxContainer/QuitButton")
		quit_button.disabled = true
		quit_button.visible = false

func _on_start_button_pressed():
	start_game.emit()

func _on_quit_button_pressed():
	get_tree().quit()
