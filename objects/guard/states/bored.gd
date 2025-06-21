extends State

@export var alert_state: State
@export var sleep_state: State
@export var navigate_state: State

var _guard : Guard

var _heard_something : bool = false
var _saw_peripheral : bool = false
var _navigate : bool = false

func _ready() -> void:
	SignalBus.connect("camera_alert", _on_camera_alert)

func _on_camera_alert(zone: String, position: Vector2) -> void:
	if zone == _guard.zone:
		_navigate = true
		_guard.navigation_target = position

func enter() -> void:
	_guard = parent
	print(_guard.name + "_Bored")
	
	$Timer.start(_guard.bored_sleep_time)
	
	# only peripheral vision enabled
	%CentralVision.monitoring = false
	%VisionLight.enabled = false
	
	super()

func exit() -> void:
	%CentralVision.monitoring = true
	_heard_something = false

# _process_physics
func process_physics(_delta: float) -> State:
	if _heard_something or _saw_peripheral:
		var dialog = Dialogue.new_dialogue("???", Dialogue.Direction.POINT_DOWN, Color(0.5, 0.5, 0.5))
		dialog.global_position = _guard.global_position
		_guard.get_parent().add_child(dialog)
		return alert_state
	
	if $Timer.is_stopped():
		return sleep_state
	
	if _navigate:
		return navigate_state
	
	return null

func _on_hearing_body_entered(body: Node2D) -> void:
	if body is Spider:
		_heard_something = true


func _on_peripheral_vision_body_entered(body: Node2D) -> void:
	if body is Spider:
		_saw_peripheral = true
