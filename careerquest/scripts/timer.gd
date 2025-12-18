extends Control

@onready var timer := $Timer
@onready var label := $time

var total_time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start() # Replace with function body.
	label.text = "00:00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.timer:
		timer_start(delta)
	else:
		total_time = 0.0
		label.text = "00:00"

func timer_start(delta):
	total_time += delta
	var m = int(total_time/60)
	var s = total_time - m * 60
	label.text = '%02d:%02d' % [m,s]
	Global.timer_info = [m, s]
