extends Camera2D

@export var attached_camera: Camera2D

var _intensity: Vector2
var _tween: Tween
var _shaking: bool = false

func _on_camera_shake(intensity: Vector2, time: float):
	_intensity = intensity
	
	if _tween and _tween.is_running():
		_tween.stop()
	
	_tween = create_tween()
	_tween.tween_property(self, "_intensity", Vector2.ZERO, time)
	await _tween.finished
	_tween = null

func _ready() -> void:
	SignalBus.camera_shake.connect(_on_camera_shake)
	
func _process(delta: float) -> void:
	if _tween:
		offset = _random_offset() * _intensity
	
	if attached_camera:
		attached_camera.offset = offset

func _random_offset() -> Vector2:
	return Vector2(
		randf_range(-_intensity.x, _intensity.x),
		randf_range(-_intensity.y, _intensity.y)
	)

func _on_test_shake() -> void:
	_on_camera_shake(Vector2(2, 2), 1.0)
