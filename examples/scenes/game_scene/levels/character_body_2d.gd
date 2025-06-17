# Player.gd
extends CharacterBody2D

@export var speed: float = 150.0

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()
