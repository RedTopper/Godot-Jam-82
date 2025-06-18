class_name State
extends Node

@export var animation_name: String

var parent: CharacterBody2D
var animations: AnimatedSprite2D
var move_component
var animation_tree: AnimationTree

func enter() -> void:
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

func get_input_vector_movement() -> Vector2:
	return move_component.get_input_vector_movement()

func get_input_forward_movement() -> float:
	return move_component.get_input_forward_movement()

func get_input_rotation() -> float:
	return move_component.get_input_rotation()
	
func get_input_hide() -> bool:
	return move_component.get_input_hide()
