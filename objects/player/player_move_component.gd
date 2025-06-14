extends Node

# get input from user
func get_movement_direction() -> Vector2:
	var input_vector = Input.get_vector("left","right","up","down")
	return input_vector
