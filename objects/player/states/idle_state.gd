extends PlayerState

#TODO: @export states that this state can transition to
@export var move_state: PlayerState

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	var input_vector = Input.get_vector("up","down","left","right")
	
	# look for user input
	if input_vector:
		return move_state
	
	return null
