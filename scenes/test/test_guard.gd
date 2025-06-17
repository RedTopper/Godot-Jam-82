extends Node2D

@onready var guard = $Monster
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guard.set_position(Vector2(650.0, 300.0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
