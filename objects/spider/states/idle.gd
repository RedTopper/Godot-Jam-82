extends State

@export var move_state: State
@export var stickbug_state: State
@export var hide_state: State

@export var stickbug_time : float = 20.0

var _spider: Spider

@onready var _timer : Timer = Timer.new()

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.body.spider_angle)
	
	_spider.velocity = Vector2.ZERO
	_spider.body.set_leg_prediction_offset(SpiderBody.Direction.NONE)
	
	animation_tree.active = true
	animation_tree["parameters/conditions/idle"] = true
	
	#%AnimationPlayer.get_animation("bob").loop_mode = Animation.LoopMode.LOOP_LINEAR
	#%AnimationPlayer.play("bob")
	
	add_child(_timer)
	_timer.one_shot = true
	_timer.start(stickbug_time)
	
	_spider.is_hiding = false
	_spider.is_moving = false
	
	super()

func process_input(_event: InputEvent) -> State:
	if get_input_forward_movement() or get_input_rotation():
		animation_tree["parameters/conditions/move"] = true
		return move_state
	
	if _timer.is_stopped():
		animation_tree["parameters/conditions/stickbug"] = true
		return stickbug_state
	
	if get_input_hide():
		animation_tree["parameters/conditions/hide"] = true
		return hide_state
	
	return null

func exit() -> void:
	remove_child(_timer)
	animation_tree["parameters/conditions/idle"] = false
