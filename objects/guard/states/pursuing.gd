extends State

@export var alert_state: State

var _guard : Guard

var _heard_something : bool = false
var _saw_peripheral : bool = false
var _saw_central : bool = false

var _state_is_active : bool = false
var _body : Spider

func enter() -> void:
	_guard = parent
	print(_guard.name + "_Pursuing")
	
	$Timer.start(_guard.pursue_time)
	
	# only peripheral vision enabled
	%VisionLight.enabled = true
	
	_saw_central = true
	_state_is_active = true
	
	%NavigationAgent.target_position = _guard.spider_pursue_location
	
	super()

func exit() -> void:
	%VisionLight.enabled = true
	
	_state_is_active = false

# _process_physics
func process_physics(_delta: float) -> State:
	if _heard_something or _saw_peripheral or _saw_central:
		$Timer.start(_guard.pursue_time)
		%NavigationAgent.target_position = _body.global_position
	
	if $Timer.is_stopped():
		return alert_state
	
	animation_name = "move_" + Utilities.get_direction_name_deg(_guard.rotation_degrees, 4)
	animations.play(animation_name)
	
	var current_guard_position = _guard.position
	var next_path_position = %NavigationAgent.get_next_path_position()
	
	var direction_vector = current_guard_position.direction_to(next_path_position)
	
	_guard.velocity = direction_vector * _guard.navigation_speed
	
	_guard.rotation = direction_vector.angle()
	
	_guard.move_and_slide()
	
	return null


func _on_hearing_body_entered(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_body = body
		if (body as Spider).is_moving:
			_heard_something = true


func _on_peripheral_vision_body_entered(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_body = body
		if not (body as Spider).is_hiding:
			_saw_peripheral = true


func _on_central_vision_body_entered(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_body = body
		if not (body as Spider).is_hiding:
			var dialog = Dialogue.new_dialogue("there it is!", Dialogue.Direction.POINT_DOWN, Color(0.5, 0.5, 0.5))
			dialog.global_position = _guard.global_position
			_guard.get_parent().add_child(dialog)
			_saw_central = true

func _on_central_vision_body_exited(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_saw_central = false


func _on_peripheral_vision_body_exited(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_saw_peripheral = false


func _on_hearing_body_exited(body: Node2D) -> void:
	if not _state_is_active: return
	if body is Spider:
		_heard_something = false
