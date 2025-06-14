extends "res://addons/maaacks_game_template/base/scenes/opening/opening.gd"

@export_group("Animation")
@export var time_between_frames : float = 1.0

func _show_next_image(animated : bool = true) -> void:
	await get_tree().create_timer(time_between_frames).timeout
	super._show_next_image(animated)
