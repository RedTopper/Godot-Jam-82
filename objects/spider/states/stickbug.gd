extends State

@export var move_state: State
@export var idle_state: State
@export var hide_state: State

var _spider: Spider
var _timer: Timer

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.body.spider_angle)
	
	_timer = Timer.new()
	
	_spider.velocity = Vector2.ZERO
	_spider.body.set_leg_prediction_offset(SpiderBody.Direction.NONE)
	
	_spider.is_hiding = false
	_spider.is_moving = false
	
	super()

func process_input(_event: InputEvent) -> State:
	if get_input_forward_movement() or get_input_rotation():
		animation_tree["parameters/conditions/move"] = true
		return move_state
	
	if get_input_hide():
		animation_tree["parameters/conditions/hide"] = true
		return hide_state
	
	return null

func exit() -> void:
	animation_tree["parameters/conditions/stickbug"] = false
