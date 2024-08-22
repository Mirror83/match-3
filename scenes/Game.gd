extends Node2D
class_name Game

signal level_complete
signal game_over

const START_GOAL = 3000
const GOAL_INCREMENT = 1000

const TIMER_INCREMENT = 10
const INITIAL_TIMER = 60

var goal = START_GOAL

var level = 1
var level_timer = INITIAL_TIMER

var timer_value = INITIAL_TIMER

var total_score = 0

var is_game_over = false
var current_level_completed = false

func _ready():
	$GameStatus.visible = false
	$Board.visible = false

func _on_board_match_found(score):
	total_score += score
	$GameStatus.set_score(total_score)
	
	if total_score >= goal and not is_game_over and not current_level_completed:
		print("Level complete")
		current_level_completed = true
		level_complete.emit()

func _on_timer_timeout():
	timer_value -= 1
	
	$GameStatus.set_timer(timer_value)
	
	if timer_value == 0:
		game_over.emit()
		$Timer.stop()

func _on_level_complete():
	$Timer.stop()
	$Board.set_process(false)
	
	var msg_box = preload("res://scenes/MessageBox.tscn").instantiate()
	msg_box.set_message("Level Complete!")
	add_child(msg_box)
	msg_box.tree_exited.connect(_go_to_next_level)
	
func _go_to_next_level():
	$Board.reset()
	$Board.set_process(true)
	
	level += 1
	$GameStatus.set_level(level)
	
	total_score = 0
	$GameStatus.set_score(total_score)
	
	goal += GOAL_INCREMENT
	$GameStatus.set_goal(goal)
	
	level_timer += TIMER_INCREMENT
	timer_value = level_timer
	
	$GameStatus.set_timer(timer_value)
	
	$Timer.start()
	
	current_level_completed = false
	
func _on_game_over():
	is_game_over = true
	$Board.set_process(false)
	
	var msg_box = preload("res://scenes/MessageBox.tscn").instantiate()
	msg_box.set_message("Game Over.")
	add_child(msg_box)
	msg_box.tree_exited.connect(_reset)

func _reset():
	$GameStatus.visible = false
	$Board.visible = false
	$Menu.visible = true
	$Board.reset()
	
	level = 1
	$GameStatus.set_level(level)
	
	total_score = 0
	$GameStatus.set_score(total_score)
	
	goal = START_GOAL
	$GameStatus.set_goal(goal)
	
	level_timer = INITIAL_TIMER
	timer_value = level_timer
	
	$Timer.stop()
	$GameStatus.set_timer(timer_value)
	
	current_level_completed = false
	is_game_over = false

func _on_menu_start_game():
	$Menu.visible = false
	
	$Board.visible = true
	$Board.set_process(true)
	
	$GameStatus.set_level(level)
	$GameStatus.set_goal(goal)
	$GameStatus.set_timer(timer_value)
	$GameStatus.set_score(total_score)
	$GameStatus.visible = true
	
	$Timer.start()
	
