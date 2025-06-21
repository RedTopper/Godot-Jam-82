extends State

@export var bored_state: State
@export var pursuit_state: State

var _guard : Guard

#@onready var _heard_something : bool = false
#@onready var _saw_peripheral : bool = false
@onready var _saw_central : bool = false

const _rotation_limit : float = 100.0

var _look_dir : float
var _initial_angle : float

func enter() -> void:
	_guard = parent
	print(_guard.name + "_Alert")
	
	_look_dir = signf(randf_range(-1.0,1.0))
	
	$Timer.one_shot = true
	$Timer.start(_guard.alert_time)
	
	%VisionLight.enabled = true
	_saw_central = false
	
	super()

func exit() -> void:
	pass
	

# _process_physics
func process_physics(delta: float) -> State:
	if _saw_central:
		return pursuit_state
	
	_guard.rotation_degrees += _guard.alert_rotate_rate * delta * _look_dir
	
	if _guard.rotation_degrees > _initial_angle + _rotation_limit:
		_look_dir *= -1.0
	elif _guard.rotation_degrees < _initial_angle - _rotation_limit:
		_look_dir *= -1.0
	
	animation_name = "idle_" + Utilities.get_direction_name_deg(_guard.rotation_degrees, 4)
	animations.play(animation_name)
	
	if $Timer.is_stopped():
		return bored_state
	
	return null


func _on_central_vision_body_entered(body: Node2D) -> void:
	if body is Spider:
		if not (body as Spider).is_hiding:
			_guard.spider_pursue_location = body.global_position
			_saw_central = true	
