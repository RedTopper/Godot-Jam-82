extends State

@export var alarm_state: State

var _camera : SecurityCamera
var _scan_direction : float = 1.0

var _spider_detected: bool = false

func enter() -> void:
	_camera = parent
	
	%VisionLight.color = Color.AQUA
	super()
	
func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	_camera.rotation_degrees += _camera.scan_speed * _scan_direction * delta
	
	if _camera.rotation_degrees > _camera.max_angle_deg:
		_camera.rotation_degrees = _camera.max_angle_deg
		_scan_direction *= -1.0
	elif _camera.rotation_degrees < _camera.min_angle_deg:
		_camera.rotation_degrees = _camera.min_angle_deg
		_scan_direction *= -1.0
	
	if _spider_detected:
		return alarm_state
	
	return null

func _on_vision_box_body_entered(body: Node2D) -> void:
	if body.name == "Spider":
		_spider_detected = true
		SignalBus.camera_alert.emit(_camera.zone, _camera.global_position + Vector2.from_angle(_camera.rotation) * _camera.alert_signal_offset)
