extends Node

func _ready() -> void:
	$DialogueAnimations.play("intro")

func _on_win_button_pressed():
	print("Button Pressed!")
	get_tree().change_scene("res://scenes/menu/lose_menu/lose_menu.tscn")
