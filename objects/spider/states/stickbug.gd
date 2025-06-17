extends State

@export var move_state: State
@export var idle_state: State

var _spider: Spider
var _time : float = 0.0
var _start_position: Vector2

var _timer: Timer

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.get_angle())
	
	_timer = Timer.new()
	
	_start_position = %Core.position
	_spider.velocity = Vector2.ZERO
	%Targets.position = Vector2.ZERO
	
	%AnimationPlayer.play("enter_stickbug")
	%AnimationPlayer.get_animation("stickbug").loop_mode = Animation.LoopMode.LOOP_LINEAR
	%AnimationPlayer.queue("stickbug")
	
	super()

func process_input(event: InputEvent) -> State:
	if get_input_forward_movement() or get_input_rotation():
		return move_state
	
	return null

func process_physics(delta: float) -> State:
	animations.position = %Core.position
	
	return null

func exit() -> void:
	%AnimationPlayer.queue("exit_stickbug")
	%AnimationPlayer.get_animation("stickbug").loop_mode = Animation.LoopMode.LOOP_NONE
