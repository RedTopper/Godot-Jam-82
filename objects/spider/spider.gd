extends CharacterBody2D
class_name Spider

@export var debug: bool = true
@export var linked_light: Node2D

@onready var body: SpiderBody = $SpiderBody

@onready var _light_vision_cone = $LightVisionCone

var is_moving : bool = false
var is_hiding : bool = false

@onready var _state_machine = $StateMachine

func _ready() -> void:
	_update_lighting_positions()
	_state_machine.init(self, body.animations, $MoveComponent, body.animation_tree)

func _physics_process(delta: float) -> void:
	_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.process_input(event)

func _process(delta: float) -> void:
	_update_lighting_positions()
	_state_machine.process_frame(delta)

func _update_lighting_positions() -> void:
	if linked_light:
		linked_light.position = body.get_core_position()
	
	body.debug_effective_scale = scale
	_light_vision_cone.position = body.get_core_position()
	_light_vision_cone.rotation_degrees = body.spider_angle
