extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var animations: AnimatedSprite2D = $Animations
@onready var move_component = $MoveComponent

var default_font: Font
var default_font_size: int

@onready var floor_anchors = $Floor/Anchors
@onready var core = $Core
@onready var floor = $Floor

var spider_angle : float = 0.0

@export var debug: bool = true

@export var leg_forward_prediction_offset: float
@export var leg_update_rate: float
@export var leg_tween_time: float
@export var rotation_speed: float
@export var movement_speed: float

@onready var ik_targets: Array[Node2D] = [
	$Floor/Targets/Leg1Target,
	$Floor/Targets/Leg2Target,
	$Floor/Targets/Leg3Target,
	$Floor/Targets/Leg4Target,
	$Floor/Targets/Leg5Target,
]

@onready var anchors: Array[Node2D] = [
	$Floor/Anchors/Leg1Anchor,
	$Floor/Anchors/Leg2Anchor,
	$Floor/Anchors/Leg3Anchor,
	$Floor/Anchors/Leg4Anchor,
	$Floor/Anchors/Leg5Anchor,
]

var update_order: Array[int] = [0, 2, 4, 1, 3]
var update_index: int = 0

func _draw() -> void:
	if debug:
		var end_point = Vector2.ZERO + Vector2.from_angle(spider_angle) * 100
		draw_line(Vector2.ZERO, end_point, Color.GREEN)
		draw_string(default_font, end_point, str(round(rad_to_deg(spider_angle))),0, -1, 12, Color.GREEN)
		draw_circle($Floor/Anchors.position, 10.0, Color.RED)

func _update_legs() -> void:
	update_index = update_index + 1
	if update_index == update_order.size():
		update_index = 0
	
	var leg = update_order[update_index]
	var tween = create_tween()
	tween.tween_property(ik_targets[leg], "global_position", anchors[leg].global_position, leg_tween_time)
	await tween.finished
	
	get_tree().create_timer(leg_update_rate).timeout.connect(_update_legs) 

func _ready() -> void:
	default_font = ThemeDB.fallback_font
	default_font_size = ThemeDB.fallback_font_size
	
	state_machine.init(self, animations, move_component)
	_update_legs()
	for node in ik_targets:
		node.top_level = true

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _process(delta: float) -> void:
	if debug:
		queue_redraw()
	state_machine.process_frame(delta)
