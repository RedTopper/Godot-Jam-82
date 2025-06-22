extends Node2D
class_name SpiderBody

# Stuff used by parent player object
@onready var animations: AnimatedSprite2D = $Animations
@onready var animation_tree: AnimationTree = $AnimationTree

@export var debug: bool = true
@export var debug_effective_scale: Vector2 = Vector2(1.0, 1.0)
@export var leg_update_rate: float = 0.02
@export var leg_tween_time: float = 0.05
@export var leg_forward_prediction_offset: float = 60.0
@export var spider_angle: float = 90.0:
	get:
		return spider_angle
	set(value):
		$Floor.rotation_degrees = value
		$Core.rotation_degrees = value
		
		# Clamp
		if value < 0.0: value += 360.0
		value = fmod(value, 360.0)
		
		if animations:
			animations.play(Utilities.get_direction_name_deg(value))
		
		spider_angle = value

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

@onready var _point_leg: Node2D = %LegFrontLeftTarget
@onready var _point_leg_ik: Node2D = %LegFrontLeftIK
var _pointing: bool = false
var _pointing_update_request: bool = false
var _point_leg_original_pos: Vector2
var _legs_fixed: bool = false

enum Direction {
	NONE,
	FORWARDS,
	BACKWARDS,
}

var _debug_font: Font
var _debug_font_size: int

var _update_index: int = 0
var _update_order: Array[int] = [0, 2, 4, 1, 3]

func set_leg_prediction_offset(direction: Direction) -> void:
	match direction:
		Direction.NONE:
			%Targets.position = Vector2.ZERO
		Direction.FORWARDS:
			%Targets.position.x = leg_forward_prediction_offset
		Direction.BACKWARDS:
			%Targets.position.x = -leg_forward_prediction_offset

func get_core_position() -> Vector2:
	return $Core.position

func point(global_pos: Vector2):
	_point_leg.top_level = true
	_pointing = true
	_pointing_update_request = true
	_point_leg.global_position = global_pos

func stop_point():
	_point_leg.top_level = false
	_pointing = false
	_point_leg.position = _point_leg_original_pos

func _draw() -> void:
	if not debug: return
	
	var end_point = Vector2.ZERO + Vector2.from_angle(deg_to_rad(spider_angle)) * 100
	draw_line(Vector2.ZERO, end_point, Color.GREEN)
	draw_string(_debug_font, end_point, str(round(spider_angle)),HORIZONTAL_ALIGNMENT_LEFT, -1, _debug_font_size, Color.GREEN)
	for node in _move_targets:
		draw_circle((node.global_position - global_position) / debug_effective_scale, 10.0, Color.RED)
	for node in _ik_targets:
		draw_circle((node.global_position - global_position) / debug_effective_scale, 10.0, Color.BLUE)

func _on_leg_update_timer_timeout() -> void:
	if not _legs_fixed:
		_legs_fixed = true
		var index = 0
		for node in _ik_targets:
			node.top_level = true
			node.global_position = _move_targets[index].global_position
			index += 1
	
	_update_index = _update_index + 1
	if _update_index == _update_order.size():
		_update_index = 0
	
	var leg = _update_order[_update_index]
	
	if _pointing and _pointing_update_request:
		var tween = create_tween()
		tween.tween_property(_point_leg_ik, "global_position", _point_leg.global_position, leg_tween_time)
		await tween.finished
		_pointing_update_request = false
	
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
			tap.top_level = true
			get_parent().add_child(tap)

func _ready() -> void:
	_debug_font = ThemeDB.fallback_font
	_debug_font_size = ThemeDB.fallback_font_size
	_point_leg_original_pos = _point_leg.position
	
	$LegUpdateTimer.start(leg_update_rate)
	$AnimationTree.active = true
	
	# Call the set function to update the angle (I promise this does something)
	spider_angle = spider_angle

func _process(_delta: float) -> void:
	if debug:
		queue_redraw()
