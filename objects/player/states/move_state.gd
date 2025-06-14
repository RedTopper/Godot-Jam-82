extends PlayerState

#TODO: @export states that this state can transition to
@export var idle_state: PlayerState

func enter() -> void:
	print("Player_Move")
	super()
	var input_vector = Input.get_vector("up","down","left","right")
	parent.velocity = input_vector * Player.SPEED

func process_input(event: InputEvent) -> State:
	var input_vector = Input.get_vector("up","down","left","right")
	
	# look for user input
	if input_vector:
		parent.velocity = input_vector * Player.SPEED
		return null
	else:
		return idle_state
