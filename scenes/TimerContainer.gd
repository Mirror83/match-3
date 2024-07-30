extends VBoxContainer

const intervals = [1, 2, 2, 3, 4, 5];
var current_times = intervals.map(func(_i): return 0);

func _on_timeout(index: int):
	current_times[index] += 1
	var new_time = current_times[index]
	
	var children = get_children();	
	for i in range(children.size()):
		# This multiplication by two is because the TimerText elements are being added
		# intermittently with their Timers in the build_timers method
		if (i == index * 2):
			children[i].update_value(current_times[index])
	

func build_timers():
	var callable = Callable(self, "_on_timeout")
	
	for i in range(intervals.size()):
		var timer_text = preload("res://scenes/TimerText.tscn").instantiate()
		add_child(timer_text)
		timer_text.update_value(current_times[i])
		
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(callable.bind(i))
		timer.start(intervals[i])

func _ready():
	build_timers()
	
