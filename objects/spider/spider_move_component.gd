extends Node

# slide movement
# movement vector
func get_input_vector_movement() -> Vector2:
	var input_vector = Input.get_vector("left","right","up","down")
	return input_vector

# tank movement
# tank forward/back
func get_input_forward_movement() -> float:
	var input = Input.get_axis("up","down")
	return input

#tank rotation
func get_input_rotation() -> float:
	var input = Input.get_axis("left","right")
	return input
