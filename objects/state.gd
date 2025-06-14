class_name State
extends Node

@export var animation_name: String
@export var move_speed : float = 400.0

var parent: CharacterBody2D
var animations: AnimatedSprite2D
var move_component

func enter() -> void:
	#animations.stop()
	animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

# _process
func process_frame(delta: float) -> State:
	return null

# _process_physics
func process_physics(delta: float) -> State:
	return null

func get_movement_input() -> Vector2:
	return move_component.get_movement_direction()
