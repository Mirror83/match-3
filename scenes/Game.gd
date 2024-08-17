extends Node2D
class_name Game

signal level_complete;

const START_GOAL = 1500
const GOAL_INCREMENT = 2000
var goal = 5000

var level = 1
var timer_value = 0

var total_score = 0

func _ready():
	$GameStatus.set_level(level)
	$GameStatus.set_score(total_score)
	$GameStatus.set_goal(goal)
	$GameStatus.set_timer(timer_value)

func _on_board_match_found(score):
	total_score += score
	$GameStatus.set_score(total_score)
	
	if total_score >= goal:
		level_complete.emit()

