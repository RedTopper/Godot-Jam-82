extends State

@export var idle_state : State
@export var move_state : State

@export var player_rotation_rate: float = 100.0

var _tank_rotation: float
var _spider: Spider

func enter() -> void:
	_spider = parent
	
	#%AnimationPlayer.play("hide")
	
	super()

func process_input(_event: InputEvent) -> State:	
	if get_input_hide():
		animation_tree["parameters/conditions/idle"] = true
		return idle_state
	
	if get_input_forward_movement():
		animation_tree["parameters/conditions/move"] = true
		return move_state
	
	return null

func process_physics(delta: float) -> State:
	var angle = _spider.spider_angle
	
	_tank_rotation = get_input_rotation()
	_spider.spider_angle = angle + _tank_rotation * player_rotation_rate * delta
	
	animation_name = Utilities.get_direction_name_deg(_spider.spider_angle)
	animations.play(animation_name)
	
	parent.move_and_slide()
	
	return null

func exit() -> void:
	animation_tree["parameters/conditions/hide"] = false
