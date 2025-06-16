extends State

@export var move_state: State
@export var bob_speed : float = 2.0
@export var bob_amplitude : float = 5.0

var _spider: Spider
var _time : float = 0.0
var _start_position: Vector2

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.get_angle())
	
	_start_position = %Core.position
	_spider.velocity = Vector2.ZERO
	%Targets.position = Vector2.ZERO
	
	super()

func process_input(event: InputEvent) -> State:
	if get_input_forward_movement() or get_input_rotation():
		return move_state
	
	return null

func process_physics(delta: float) -> State:
	%Core.position = idle_bob(delta)
	animations.position = %Core.position
	
	return null

func exit() -> void:
	%Core.position = _start_position

func idle_bob(delta: float) -> Vector2:
	var offset = sin(_time * bob_speed) * bob_amplitude
	_time += delta
	_time = fmod(_time, PI)
	return Vector2(_start_position.x, _start_position.y + offset)
