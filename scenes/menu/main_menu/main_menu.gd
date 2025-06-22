extends MainMenu

@export var tween_time: float = 0.5
@export var spider_ui_offset: float = 350

@onready var _animation: AnimationPlayer = $AnimationPlayer
@onready var _light: PointLight2D = $Light/Control/PointLight2D
@onready var _spider: SpiderBody = $Background/Control/SpiderBody

var _next_x: float = 0.0
var _has_next_x: bool = false

var _tween: Tween
var _tween_finished: bool = false
var _animation_finished: bool = false

func _on_tween_finished():
	_tween_finished = true
	if _has_next_x:
		_has_next_x = false
		_tween_spider_x(_next_x)
	
func _on_animation_finished(_string_name: StringName):
	_animation_finished = true
	_tween_finished = true

func _on_hover(node: Control):
	_move(node.global_position + node.size / Vector2(2.0, 2.0))

func _on_press(node: Control):
	_move(node.global_position + node.size / Vector2(2.0, 2.0))

func _on_light_update() -> void:
	_light.energy = randf() * 0.1 + 0.9

func _on_credits_button_pressed_stop_point() -> void:
	await get_tree().process_frame
	_spider.stop_point()

func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_hover)
	_connect_all_children()
	_animation.play("walk_in")
	_animation.animation_finished.connect(_on_animation_finished)
	super()

func _tween_spider_x(next_x: float):
	_tween = create_tween()
	_tween.tween_property(_spider, "global_position:x", next_x, tween_time)
	_tween.finished.connect(_on_tween_finished)
	_tween_finished = false

func _move(pos: Vector2):
	_spider.point(pos)
	_light.global_position = pos
	var next_x = pos.x - spider_ui_offset
	if _tween_finished and _animation_finished:
		_tween_spider_x(next_x)
	else:
		_next_x = next_x
		_has_next_x = true

func _connect_all_children() -> void:
	await get_tree().process_frame 
	var waiting = get_children()
	while waiting.size():
		var node = waiting.pop_back() as Node
		waiting.append_array(node.get_children())
		if node is Button:
			var button: Button = node
			if not button.mouse_entered.is_connected(_on_hover.bind(button)):
				print("new bind")
				button.mouse_entered.connect(_on_hover.bind(button))
				button.pressed.connect(_on_press.bind(button))
