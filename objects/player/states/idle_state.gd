# idle state
extends State

@export var move_state: State

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var name = self.get_path().get_name(path_index-2)
	print(name + "_Idle")
	
	animation_name = "idle_down"
	
	get_movement_input()
	
	super()
	
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	# look for user input
	if get_movement_input():
		return move_state
	
	return null
