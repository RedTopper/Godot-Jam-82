extends GPUParticles2D
class_name Explode

const scene = preload("res://objects/particle_explosion/explode.tscn")

static func new_explosion() -> Explode:
	return scene.instantiate()

func _on_timer_timeout() -> void:
	queue_free()

func _ready() -> void:
	SignalBus.camera_shake.emit(Vector2(10, 10), 1.5)
