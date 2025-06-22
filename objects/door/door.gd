extends StaticBody2D

@export var linked_blocker: LightOccluder2D
@export var explode_on_close: bool = false

@onready var _physics: CollisionShape2D = $Physics
@onready var _animation: AnimatedSprite2D = $DoorAnimation
@onready var _audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _light: LightOccluder2D = $DoorLightBlocker

var _num_bodies_inside: int = 0
var _exploded: bool = false

func _door_open() -> void:
	if _exploded: return
	
	if _num_bodies_inside == 0:
		if linked_blocker:
			linked_blocker.visible = false
			
		_animation.play("door opening")
		_audio.play()
		_physics.set_deferred("disabled", true)
		_light.visible = false
		
	_num_bodies_inside += 1
	
func _door_close() -> void:
	if _exploded: return
	
	_num_bodies_inside -= 1
	
	if _num_bodies_inside == 0:
		if explode_on_close:
			var explode = Explode.new_explosion()
			add_child(explode)
			explode.position = $DoorAnimation.position
			_exploded = true
			return
		
		if linked_blocker:
			linked_blocker.visible = true
		
		_animation.play("door closing")
		_audio.play()
		_physics.set_deferred("disabled", false)
		_light.visible = true

func _is_allowed(body: Node2D):
	if body is Guard:
		return true
	
	if body is Spider:
		if body.has_keycard:
			return true
	
	return false

func _on_door_open_body_entered(body: Node2D) -> void:
	if _is_allowed(body):
		_door_open()

func _on_door_open_body_exited(body: Node2D) -> void:
	if _is_allowed(body):
		_door_close()
