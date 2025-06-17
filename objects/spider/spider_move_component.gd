extends Node

# slide movement
# movement vector
func get_input_vector_movement() -> Vector2:
	return Input.get_vector("left","right","up","down")

# tank movement
# tank forward/back
func get_input_forward_movement() -> float:
	return Input.get_axis("up","down")

#tank rotation
func get_input_rotation() -> float:
	return Input.get_axis("left","right")

#toggle hiding
func get_input_hide() -> bool:
	return Input.is_action_just_pressed("toggle_hide")
