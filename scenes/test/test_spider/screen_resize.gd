extends SubViewport

@export var shadow_margin = Vector2i(100, 100)

func _process(_delta):
	size = get_tree().root.size + shadow_margin
