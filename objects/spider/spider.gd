extends CharacterBody2D
class_name Spider

@export var debug: bool = true
@export var leg_update_rate: float = 0.02
@export var leg_tween_time: float = 0.05
@export var linked_light: Node2D

@onready var _state_machine = $StateMachine

@onready var _ik_targets: Array[Node2D] = [
	%LegFrontLeftIK,
	%LegRearLeftIK,
	%LegRearIK,
	%LegRearRightIK,
	%LegFrontRightIK,
]

@onready var _move_targets: Array[Node2D] = [
	%LegFrontLeftTarget,
	%LegRearLeftTarget,
	%LegRearTarget,
	%LegRearRightTarget,
	%LegFrontRightTarget,
]

var _debug_font: Font
var _debug_font_size: int

var _update_index: int = 0
var _update_order: Array[int] = [0, 2, 4, 1, 3]

var _angle : float = 90.0

func get_angle() -> float:
	return _angle
	
func set_angle(angle: float) -> void:
	$Floor.rotation_degrees = angle
	$Core.rotation_degrees = angle
	
	# Clamp
	if angle < 0.0: angle += 360.0
	angle = fmod(angle, 360.0)
	
	_angle = angle

func _draw() -> void:
	if not debug: return
	
	var end_point = Vector2.ZERO + Vector2.from_angle(deg_to_rad(_angle)) * 100
	draw_line(Vector2.ZERO, end_point, Color.GREEN)
	draw_string(_debug_font, end_point, str(round(_angle)),HORIZONTAL_ALIGNMENT_LEFT, -1, _debug_font_size, Color.GREEN)
	for node in _move_targets:
		draw_circle(node.global_position - global_position, 10.0, Color.RED)
	for node in _ik_targets:
		draw_circle(node.global_position - global_position, 10.0, Color.BLUE)

func _update_legs() -> void:
	_update_index = _update_index + 1
	if _update_index == _update_order.size():
		_update_index = 0
	
	var leg = _update_order[_update_index]
	
	if _ik_targets[leg].global_position.distance_to(_move_targets[leg].global_position) > 1.0:
		var tween = create_tween()
		tween.tween_property(_ik_targets[leg], "global_position", _move_targets[leg].global_position, leg_tween_time)
		
		await tween.finished
		
		#var tap = Dialogue.new_dialogue("*tap*", Dialogue.Direction.POINT_DOWN, Color(0.5, 0.5, 0.5))
		#tap.global_position = _move_targets[leg].global_position
		#get_parent().add_child(tap)
		if randf() < 0.2:
			var tap = Ping.new_ping(5, 15, 2, Color(0.5, 0.5, 0.5))
			tap.global_position = _move_targets[leg].global_position
			get_parent().add_child(tap)
		
	get_tree().create_timer(leg_update_rate).timeout.connect(_update_legs) 

func _ready() -> void:
	_debug_font = ThemeDB.fallback_font
	_debug_font_size = ThemeDB.fallback_font_size
	
	$AnimationTree.active = true
	
	_state_machine.init(self, $Animations, $MoveComponent, $AnimationTree)
	_update_legs()
	
	var index = 0
	for node in _ik_targets:
		node.top_level = true
		node.global_position = _move_targets[index].global_position
		index += 1

func _physics_process(delta: float) -> void:
	_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	_state_machine.process_input(event)

func _process(delta: float) -> void:
	if debug:
		queue_redraw()
	if linked_light:
		linked_light.global_position = %Core/Skeleton2D.global_position
	_state_machine.process_frame(delta)
