extends Node2D

@onready var player = $"Player"
@onready var sound = $"SpatialAudioNode"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = Vector2(500, 0)
	sound.position = Vector2(500, 500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sound.set_player_position(player.position)
	sound.set_player_facing(player.rotation + PI/2)
