extends State

@export var bored_state: State
@export var alert_state: State

var _guard : Guard

@onready var _heard_something : bool = false
@onready var _saw_peripheral : bool = false
@onready var _saw_central : bool = false


func enter() -> void:
	_guard = parent
	print(_guard.name + "_Navigating")
	
	%VisionLight.enabled = true
	
	super()

func exit() -> void:
	%VisionLight.enabled = false
	_saw_central = false
	_saw_peripheral = false
	_heard_something = false

# _process_physics
func process_physics(_delta: float) -> State:
	if _saw_central or _saw_peripheral or _heard_something:
		return alert_state
	
	%NavigationAgent.target_position = _guard.navigation_target
	
	var current_guard_position = _guard.position
	var next_path_position = %NavigationAgent.get_next_path_position()
	
	var direction_vector = current_guard_position.direction_to(next_path_position)
	
	_guard.velocity = direction_vector * _guard.navigation_speed
	
	_guard.rotation = direction_vector.angle()
	
	animation_name = "move_" + Utilities.get_direction_name_deg(_guard.rotation_degrees, 4)
	animations.play(animation_name)
	
	_guard.move_and_slide()
	
	if %NavigationAgent.is_navigation_finished():
		return bored_state
	
	return null


func _on_central_vision_body_entered(body: Node2D) -> void:
	if body is Spider:
		_saw_central = true

func _on_peripheral_vision_body_entered(body: Node2D) -> void:
	if body is Spider:
		_saw_peripheral = true

func _on_hearing_body_entered(body: Node2D) -> void:
	if body is Spider:
		_heard_something = true
