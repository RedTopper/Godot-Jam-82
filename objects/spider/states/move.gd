extends State

@export var idle_state: State

@export var player_linear_rate: float = 400.0
@export var player_rotation_rate: float = 200.0
@export var leg_forward_prediction_offset: float = 60.0
@export var move_sound_stream: AudioStreamPlayer

var _spider: Spider
var _tank_motion: float
var _tank_rotation: float

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.get_angle())
	
	_tank_motion = get_input_forward_movement()
	_tank_rotation = get_input_rotation()
	
	move_sound_stream.play()
	super()

func process_input(_event: InputEvent) -> State:
	_tank_motion = get_input_forward_movement()
	_tank_rotation = get_input_rotation()
	
	# look for user input
	if _tank_motion or _tank_rotation:
		return null
	
	animation_tree["parameters/conditions/idle"] = true
	
	return idle_state

func process_physics(delta: float) -> State:
	var angle = _spider.get_angle()
	_spider.velocity = Vector2.RIGHT.rotated(deg_to_rad(angle)) * -_tank_motion * player_linear_rate * _spider.scale.x
	_spider.set_angle(angle + _tank_rotation * player_rotation_rate * delta)
	
	animation_name = Utilities.get_direction_name_deg(_spider.get_angle())
	animations.play(animation_name)
	
	# leg movement ahead of spider
	if _tank_motion > 0:
		%Targets.position.x = -leg_forward_prediction_offset
	elif _tank_motion < 0:
		%Targets.position.x = leg_forward_prediction_offset
	else:
		%Targets.position = Vector2.ZERO
	
	parent.move_and_slide()
	
	return null

func exit() -> void:
	move_sound_stream.stop()
	animation_tree["parameters/conditions/move"] = false
