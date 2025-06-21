class_name SecurityCamera
extends CharacterBody2D

@onready var _state_machine = $StateMachine

@export var debug : bool = false
@export var min_angle_deg : float = 0.0
@export var max_angle_deg : float = 90.0
@export var scan_speed: float = 9.0 # deg/s
@export var alarm_reset_time: float = 10.0 # s
@export var zone : String = "default"
@export var alert_signal_offset : float = 200.0

var _debug_font: Font
var _debug_font_size: int

func _ready() -> void:
	_debug_font = ThemeDB.fallback_font
	_debug_font_size = ThemeDB.fallback_font_size
	
	_state_machine.init(self, $Images, null, null)

func _physics_process(delta: float) -> void:
	_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.process_input(event)

func _process(delta: float) -> void:
	if debug:
		queue_redraw()
	_state_machine.process_frame(delta)
