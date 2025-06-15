extends Sprite2D

@export var rotation_images: Array[Texture2D]
@export var rotation_source: Node2D

func _process(delta: float) -> void:
	var step = 360.0 / rotation_images.size()
	var deg = fmod(rotation_source.rotation_degrees, 360)
	
	if deg < 0.0: 
		deg += 360.0
	
	var index = int((deg + (step / 2.0)) / step) % rotation_images.size()
	texture = rotation_images[index]
