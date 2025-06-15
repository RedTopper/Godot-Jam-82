extends CharacterBody2D

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
	_update_legs()
	for node in ik_targets:
		node.top_level = true

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left","right","up","down")
	
	var rotate = input_vector.x * delta * rotation_speed
	$Core.rotation += rotate
	$Floor.rotation += rotate
	
	var speed = -input_vector.y * movement_speed
	velocity = Vector2(0.0, speed).rotated($Core.rotation)
	
	if speed > 0.0:
		$Floor/Anchors.position.y = leg_forward_prediction_offset
	elif speed < 0.0:
		$Floor/Anchors.position.y = -leg_forward_prediction_offset
	else:
		$Floor/Anchors.position.y = 0
	
	move_and_slide()
