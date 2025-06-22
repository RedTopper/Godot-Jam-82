class_name Dialogue
extends Node2D

@export var text: String = "*Sample Text*"
@export var border: Color
@export var background: Color
@export var direction: Direction = Direction.POINT_UP

@onready var _root: Node2D = $Root
@onready var _panel: PanelContainer = $CanvasGroup/Panel/PanelContainer
@onready var _border: Polygon2D = $CanvasGroup/Arrow/DirectionBorder
@onready var _internal: Polygon2D = $CanvasGroup/Arrow/DirectionInternal
@onready var _label: RichTextLabel = $CanvasGroup/Panel/PanelContainer/MarginContainer/RichTextLabel
@onready var _anim: AnimationPlayer = $AnimationPlayer

const scene = preload("res://objects/dialogue/dialogue.tscn")

enum Direction {
	POINT_AUTO,
	POINT_DOWN,
	POINT_LEFT,
	POINT_RIGHT,
	POINT_UP,
}

static func new_dialogue(text_p: String, direction_p: Direction = Direction.POINT_AUTO, border_p: Color = Color(0.9, 0.9, 0.9), background_p: Color = Color(0.1, 0.1, 0.1)) -> Dialogue:
	var dialogue: Dialogue = scene.instantiate()
	dialogue.text = text_p
	dialogue.direction = direction_p
	dialogue.border = border_p
	dialogue.background = background_p
	return dialogue

func _ready() -> void:
	var styleBox = _panel.get_theme_stylebox("panel")
	styleBox.set("bg_color", background)
	styleBox.set("border_color", border)
	
	_panel.add_theme_stylebox_override("panel", styleBox)
	_border.color = border
	_internal.color = background
	_label.text = ""
	_label.push_color(Color(border))
	_label.add_text(text)
	_label.pop()
	
	if direction == Direction.POINT_AUTO:
		#direction = _calculate_orientation()
		pass
	
	_set_orientation()
			
	_anim.play("popup")
	
	await _anim.animation_finished
	
	queue_free()

func _set_orientation():
	match direction:
		Direction.POINT_UP:
			_root.rotation_degrees = 180
			_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
			_panel.grow_vertical = Control.GROW_DIRECTION_END
		Direction.POINT_AUTO, Direction.POINT_DOWN:
			_root.rotation_degrees = 0
			_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
			_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
		Direction.POINT_LEFT:
			_root.rotation_degrees = 90
			_panel.grow_horizontal = Control.GROW_DIRECTION_END
			_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
		Direction.POINT_RIGHT:
			_root.rotation_degrees = 270
			_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
			_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
