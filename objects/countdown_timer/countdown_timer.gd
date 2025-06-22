extends Node2D
class_name CountdownTimer

@export var time: float = 0.0

func _process(delta: float) -> void:
	var minutes := time / 60.0
	var seconds := fmod(time, 60.0)
	var ms := fmod(seconds * 100.0, 100.0)
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, ms]
	$Label.text = time_string
