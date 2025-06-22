class_name Ping
extends Node2D

@export var radius_min: float = 10.0
@export var radius_max: float = 50.0
@export var width: float = 5.0
@export var color: Color = Color("white")

@export var anim_radius: float = 0.0
@export var anim_alpha: float = 1.0

@onready var _anim: AnimationPlayer = $AnimationPlayer

const scene = preload("res://objects/ping/ping.tscn")

static func new_ping(radius_min_p: float = 10.0, radius_max_p: float = 50.0, width_p: float = 5.0, color_p: Color = Color("white")) -> Ping:
	var ping: Ping = scene.instantiate()
	ping.radius_min = radius_min_p
	ping.radius_max = radius_max_p
	ping.width = width_p
	ping.color = color_p
	return ping

func _ready() -> void:
	_anim.play("circle")
	await _anim.animation_finished
	queue_free()

func _draw() -> void:
	draw_circle(Vector2(), anim_radius * radius_max + radius_min, Color(color, anim_alpha), false, width, true)

func _process(_delta: float) -> void:
	queue_redraw()
