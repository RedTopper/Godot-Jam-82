# idle state
extends State

@export var move_state: State

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var name = self.get_path().get_name(path_index-2)
	print(name + "_Idle")
	
	animation_name = "idle_" + Utilities.get_direction_name(Globals.player_direction)
	
	super()
	
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	# look for user input
	if get_input_forward_movement() or get_input_rotation():
		return move_state
	
	return null
