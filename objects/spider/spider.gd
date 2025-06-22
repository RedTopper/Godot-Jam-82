extends CharacterBody2D
class_name Spider

@export var debug: bool = true

@onready var body: SpiderBody = $SpiderBody

@onready var _light_vision_cone = $LightVisionCone

var is_moving: bool = false
var is_hiding: bool = false
var has_keycard: bool = false

@onready var _state_machine = $StateMachine

func say(text: String) -> void:
	var dialog = Dialogue.new_dialogue(text, Dialogue.Direction.POINT_DOWN)
	dialog.global_position = global_position
	get_parent().add_child(dialog)

func _ready() -> void:
	body.debug = debug
	_state_machine.init(self, body.animations, $MoveComponent, body.animation_tree)

func _physics_process(delta: float) -> void:
	_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.process_input(event)

func _process(delta: float) -> void:
	body.debug = debug
	body.debug_effective_scale = scale
	_light_vision_cone.position = body.get_core_position()
	_light_vision_cone.rotation_degrees = body.spider_angle
	
	_state_machine.process_frame(delta)
