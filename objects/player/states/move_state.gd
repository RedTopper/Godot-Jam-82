extends State

#TODO: @export states that this state can transition to
@export var idle_state: State

var tank_motion: float
var tank_rotation: float

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var name = self.get_path().get_name(path_index-2)
	print(name + "_Move")
	
	animation_name = "move_" + Utilities.get_direction_name(Globals.player_direction)
	
	tank_motion = get_input_forward_movement()
	tank_rotation = get_input_rotation()
	
	super()
	

func process_input(event: InputEvent) -> State:
	tank_motion = get_input_forward_movement()
	tank_rotation = get_input_rotation()
	
	# look for user input
	if tank_motion or tank_rotation:
		return null
	else:
		return idle_state

func process_physics(delta: float) -> State:
	parent.velocity = Vector2.RIGHT.rotated(Globals.player_direction) * -tank_motion * Globals.player_linear_rate
	Globals.player_direction += (tank_rotation * Globals.player_rotation_rate * delta)
	
	Globals.player_direction = fmod(Globals.player_direction, TAU)
	if Globals.player_direction < 0.0:
		Globals.player_direction += TAU
	
	animation_name = "move_" + Utilities.get_direction_name(Globals.player_direction)
	animations.play(animation_name)
	
	parent.move_and_slide()
	
	return null
