extends HFlowContainer

@export
var label = "Timer";
@export
var value = "";


# Called when the node enters the scene tree for the first time.
func _ready():
	$Value.text = value;


func update_value(num: int):
	$Value.text = "%d seconds" % num
