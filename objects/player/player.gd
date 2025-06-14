class_name Player extends CharacterBody2D


const SPEED = 300.0
const ROTATION_SPEED = PI / 2

func _init():
	$AudioListener2D.make_current()

func _process(delta):
	var rotation_direction = 0
	if Input.is_action_pressed("ui_left"):
		rotation_direction += -1
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	rotation += rotation_direction * ROTATION_SPEED * delta
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity = Vector2.DOWN.rotated(-rotation) * SPEED
	position += velocity * delta
