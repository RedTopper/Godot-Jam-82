class_name State extends Node

func enter() -> void:
	pass

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
