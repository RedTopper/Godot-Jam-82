extends Timer

@export var timers: Array[CountdownTimer]

func _process(delta: float) -> void:
	for timer in timers:
		if timer:
			timer.time = time_left
