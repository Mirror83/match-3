extends Control
class_name GameStatus

func set_level(level: int):
	$HBoxContainer/Values/Level.text = "%d" % level

func set_timer(timer_value: int):
	$HBoxContainer/Values/Timer.text = "%d" % timer_value
	
func set_score(score: int):
	$HBoxContainer/Values/Score.text = "%d" % score
	
func set_goal(goal: int):
	$HBoxContainer/Values/Goal.text = "%d" % goal
	
