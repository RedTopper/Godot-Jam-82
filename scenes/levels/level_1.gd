extends Node

func _ready():
	await get_tree().process_frame
	print("READY CALLED after frame")
	_update_all_tilemap_shader_params()
	get_viewport().connect("size_changed", Callable(self, "_viewport_changed"))

func _viewport_changed():
	_update_all_tilemap_shader_params()

func _update_all_tilemap_shader_params():
	var size := get_viewport().get_visible_rect().size
	print("Viewport size being set to: ", size)

	for tilemap in get_tree().get_nodes_in_group("tilemap_shader_users"):
		if tilemap.material is ShaderMaterial:
			tilemap.material.set_shader_parameter("viewport_size", size)
			print("Set on: ", tilemap.name, " → ", tilemap.material.get_shader_parameter("viewport_size"))
