extends State

@export var scan_state: State

var _camera : SecurityCamera
var _spider_present : bool = true

func enter() -> void:
	_camera = parent
	
	%VisionLight.color = Color.RED

func exit() -> void:
	%VisionLight.color = Color.AQUA

func process_frame(_delta: float) -> State:
	if $ExitTimer.is_stopped() and not(_spider_present):
		return scan_state
	
	return null

func _on_vision_box_body_entered(body: Node2D) -> void:
	if body.name == "Spider":
		_spider_present = true

func _on_vision_box_body_exited(body: Node2D) -> void:
	if body.name == "Spider":
		_spider_present = false
		$ExitTimer.one_shot = true
		$ExitTimer.start(_camera.alarm_reset_time)
