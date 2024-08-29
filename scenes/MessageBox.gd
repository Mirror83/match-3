extends Control

var message: String;

func set_message(msg: String):
	message = msg

func _ready():
	$ColorRect/Label.text = message
	var screen_size = get_viewport_rect().size
	$ColorRect.visible = false
	await get_tree().create_timer(1).timeout
	$ColorRect.visible = true
	
	var tween = create_tween()
	tween.tween_property(
		$ColorRect, "position",
		Vector2(
			$ColorRect.position.x,
			screen_size.y / 2 - $ColorRect.get_rect().size.y / 2
		),
		0.5
	)
	tween.tween_property(
		$ColorRect, "position",
		Vector2($ColorRect.position.x, screen_size.y),
		0.5
	).set_delay(2)
	tween.tween_callback(func(): queue_free())
