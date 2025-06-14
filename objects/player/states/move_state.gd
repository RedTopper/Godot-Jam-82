extends State

#TODO: @export states that this state can transition to
@export var idle_state: State

var input_vector : Vector2

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var name = self.get_path().get_name(path_index-2)
	print(name + "_Move")
	
	input_vector = get_movement_input()
	animation_name = "move" + get_movement_direction(input_vector)
	
	super()
	

func process_input(event: InputEvent) -> State:
	input_vector = get_movement_input()
	animation_name = "move" + get_movement_direction(input_vector)
	
	animations.play(animation_name)
	
	# look for user input
	if input_vector:
		return null
	else:
		return idle_state

func process_physics(delta: float) -> State:
	
	var movement = input_vector * move_speed
	parent.velocity = movement
	
	parent.move_and_slide()
	
	return null

func get_movement_direction(movement_vector: Vector2) -> String:
	var input_direction = movement_vector.snapped(Vector2.ONE)
	
	if input_direction == Vector2.UP:
		return "_up"
	elif input_direction == Vector2.DOWN:
		return "_down"
	elif input_direction == Vector2.LEFT:
		return "_left"
	else: #input_direction == Vector2.RIGHT:
		return "_right"
