extends State

@export var idle_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var tank_motion: float
var tank_rotation: float

func enter() -> void:
	# debug
	var path_index = self.get_path().get_name_count() - 1
	var dbg_name = self.get_path().get_name(path_index-2)
	print(dbg_name + "_Move")
	
	animation_name = Utilities.get_direction_name(parent.spider_angle)
	
	tank_motion = get_input_forward_movement()
	tank_rotation = get_input_rotation()
	
	super()
	

func process_input(event: InputEvent) -> State:
	tank_motion = get_input_forward_movement()
	tank_rotation = get_input_rotation()
	
	# look for user input
	if tank_motion or tank_rotation:
		return null
	else:
		return idle_state

func process_physics(delta: float) -> State:
	parent.velocity = Vector2.RIGHT.rotated(parent.spider_angle) * -tank_motion * Globals.player_linear_rate
	parent.spider_angle += (tank_rotation * Globals.player_rotation_rate * delta)
	
	parent.spider_angle = fmod(parent.spider_angle, TAU)
	if parent.spider_angle < 0.0:
		parent.spider_angle += TAU
	
	animation_name = Utilities.get_direction_name(parent.spider_angle)
	animations.play(animation_name)
	
	# leg movement ahead of spider
	if tank_motion:
		parent.floor_anchors.position = -parent.leg_forward_prediction_offset * parent.velocity.normalized()#.rotated(parent.spider_angle)
	else:
		parent.floor_anchors.position = Vector2.ZERO
	
		
	parent.core.rotation = parent.spider_angle
	parent.floor.rotation = parent.spider_angle
	
	parent.move_and_slide()
	
	return null
