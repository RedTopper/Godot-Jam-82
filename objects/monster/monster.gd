class_name Monster
extends CharacterBody2D

@onready var state_machine = $StateMachine

const SPEED = 300.0

func _ready() -> void:
	#initialize state machine
	pass
	
func _process(delta: float) -> void:
	pass
