extends State

@export var move_state: State
@export var stickbug_state: State

@export var bob_speed : float = 2.0
@export var bob_amplitude : float = 5.0

@export var stickbug_time : float = 20.0

var _spider: Spider

@onready var _timer : Timer = Timer.new()

func enter() -> void:
	_spider = parent
	
	animation_name = Utilities.get_direction_name_deg(_spider.get_angle())
	
	_spider.velocity = Vector2.ZERO
	%Targets.position = Vector2.ZERO
	
	%AnimationPlayer.get_animation("bob").loop_mode = Animation.LoopMode.LOOP_LINEAR
	%AnimationPlayer.play("bob")
	
	add_child(_timer)
	_timer.one_shot = true
	_timer.start(stickbug_time)
	
	super()

func process_input(event: InputEvent) -> State:
	if get_input_forward_movement() or get_input_rotation():
		return move_state
	
	if _timer.is_stopped():
		return stickbug_state
	
	return null

func process_physics(delta: float) -> State:
	return null

func exit() -> void:
	%AnimationPlayer.queue("RESET")
	%AnimationPlayer.get_animation("bob").loop_mode = Animation.LoopMode.LOOP_NONE
	
	remove_child(_timer)
