extends Node

@export var next_scene: PackedScene

func _ready() -> void:
	$DialogueAnimations.play("intro")

func _on_win_button_pressed():
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
