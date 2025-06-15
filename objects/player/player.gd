class_name Player
extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations: AnimatedSprite2D = $Animations
@onready var move_component = $MoveComponent

@export var debug : bool = true

var default_font: Font
var default_font_size: int

func _draw() -> void:
	if debug:
		var end_point = Vector2.ZERO + Vector2.from_angle(Globals.player_direction) * 100
		draw_line(Vector2.ZERO, end_point, Color.GREEN)
		draw_string(default_font, end_point, str(round(rad_to_deg(Globals.player_direction))),0, -1, 12, Color.GREEN)

func _ready() -> void:
	default_font = ThemeDB.fallback_font
	default_font_size = ThemeDB.fallback_font_size
	
	#initialize state machine
	state_machine.init(self, animations, move_component)
	$AudioListener2D.make_current()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	if debug:
		queue_redraw()
	state_machine.process_frame(delta)
