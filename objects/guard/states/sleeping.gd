extends State

@export var bored_state: State
@export var alert_state: State

var _guard : Guard

var _heard_something : bool = false

func enter() -> void:
	_guard = parent
	print(_guard.name + "_Sleeping")
	
	$Timer.start(_guard.sleep_time)
	
	# close eyes for sleepytime
	%CentralVision.monitoring = false
	%PeripheralVision.monitoring = false
	%VisionLight.enabled = false
	
	super()

func exit() -> void:
	%CentralVision.monitoring = true
	%PeripheralVision.monitoring = true

#func process_input(_event: InputEvent) -> State:
	#return null
#
## _process
#func process_frame(_delta: float) -> State:
	#return null

# _process_physics
func process_physics(_delta: float) -> State:
	if _heard_something:
		var dialog = Dialogue.new_dialogue("what was that?", Dialogue.Direction.POINT_DOWN, Color(0.5, 0.5, 0.5))
		dialog.global_position = _guard.global_position
		_guard.get_parent().add_child(dialog)
		return alert_state
	
	if $Timer.is_stopped():
		return bored_state
	
	return null

func _on_hearing_body_entered(body: Node2D) -> void:
	if body is Spider or body is Guard:
		_heard_something = true
