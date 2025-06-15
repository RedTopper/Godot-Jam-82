extends Node

var bus_count = 1 #Always have master bus

func create_bus(prefix: String) -> String:
	AudioServer.add_bus(bus_count)
	var bus_name = prefix + str(bus_count)
	AudioServer.set_bus_name(bus_count, bus_name)
	bus_count += 1
	return bus_name
	
func remove_bus(busName: String) -> void:
	var busID = AudioServer.get_bus_index(busName)
	AudioServer.remove_bus(busID)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
