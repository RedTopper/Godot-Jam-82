class_name Guard
extends CharacterBody2D

@export var debug : bool = false

@export var sleep_time : float = 60.0

@export var bored_sleep_time : float = 30.0

@export var alert_rotate_rate : float = 90.0
@export var alert_time : float = 5.0

@export var pursue_time : float = 10.0
@export var pursue_speed : float = 100.0
var spider_pursue_location : Vector2

@export var navigation_speed : float = 50.0

@export var zone : String = "default"

var navigation_target : Vector2

@onready var _state_machine = $StateMachine

var _debug_font: Font
var _debug_font_size: int

func _draw() -> void:
	if not debug:
		return
	
	draw_string(_debug_font, Vector2(0.0, -100.0),_state_machine.current_state.name,HORIZONTAL_ALIGNMENT_CENTER,-1,_debug_font_size)

func _nav_setup():
	await get_tree().physics_frame

func _ready() -> void:
	_debug_font = ThemeDB.fallback_font
	_debug_font_size = ThemeDB.fallback_font_size
	
	%NavigationAgent.path_desired_distance = 4.0
	%NavigationAgent.target_desired_distance = 4.0
	
	_state_machine.init(self, $Images, null, null)
	
	await _nav_setup()

func _physics_process(delta: float) -> void:
	_state_machine.process_physics(delta)
	$Images.rotation_degrees = -rotation_degrees
	$GuardCollisionBox.rotation_degrees = -rotation_degrees

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.process_input(event)

func _process(delta: float) -> void:
	if debug:
		queue_redraw()
	_state_machine.process_frame(delta)
