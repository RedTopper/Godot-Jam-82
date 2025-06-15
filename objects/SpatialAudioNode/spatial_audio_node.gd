extends Node2D

var player_vector = Vector2.ZERO
var player_facing = 0
var audio_bus_name = ""
var panning_effect = null
@onready var sound = $"AudioStreamPlayer2D"
@export var stream: AudioStream

func set_player_position(vector: Vector2):
	player_vector = vector

func set_player_facing(rads: float):
	player_facing = rads

func play_sound() -> void:
	if !sound.playing:
		sound.play()

func _ready() -> void:
	audio_bus_name = AudioBusManager.create_bus("SFX")
	var busID = AudioServer.get_bus_index(audio_bus_name)
	panning_effect = AudioEffectPanner.new()
	AudioServer.add_bus_effect(busID, panning_effect)
	sound.set_bus(audio_bus_name)
	sound.set_stream(stream)

func _process(delta: float) -> void:
	var angle_to_sound = player_vector.angle_to_point(position)
	var heard_angle = player_facing - angle_to_sound
	panning_effect.set_pan(cos(heard_angle))

func _exit_tree() -> void:
	AudioBusManager.remove_bus(audio_bus_name)
