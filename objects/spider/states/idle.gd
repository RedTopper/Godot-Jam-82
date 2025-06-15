extends State

@export var move_state: State

var time : float = 0.0
var bob_speed : float = 2.0
var bob_amplitude : float = 5.0

var start_position: Vector2

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var dbg_name = self.get_path().get_name(path_index-2)
	print(dbg_name + "_Idle")
	
	animation_name = Utilities.get_direction_name(parent.spider_angle)
	
	parent.floor_anchors.position = Vector2.ZERO
	
	start_position = parent.core.position
	
	super()
	
	parent.velocity = Vector2.ZERO


func process_input(event: InputEvent) -> State:
	# look for user input
	if get_input_forward_movement() or get_input_rotation():
		return move_state
	
	return null

func process_physics(delta: float) -> State:
	parent.core.position = idle_bob(delta)
	animations.position = parent.core.position
	return null

func exit() -> void:
	parent.core.position = start_position

func idle_bob(delta: float) -> Vector2:
	var offset = sin(time * bob_speed) * bob_amplitude
	time += delta
	time = fmod(time, PI)
	return Vector2(start_position.x, start_position.y + offset)
