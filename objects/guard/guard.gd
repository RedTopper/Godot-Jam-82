class_name Guard
extends CharacterBody2D

@onready var state_machine = $StateMachine

var _angle : float = 90.0

func get_angle() -> float:
	return _angle

func set_angle(angle: float) -> void:
	# Clamp
	if angle < 0.0: angle += 360.0
	angle = fmod(angle, 360.0)
	
	_angle = angle
